Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXJ3Hg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXJ3Hg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXJ3Hgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:36:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52509
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbXJ3Hgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:36:48 -0400
Date: Tue, 30 Oct 2007 00:36:22 -0700 (PDT)
Message-Id: <20071030.003622.265888160.davem@davemloft.net>
To: horms@verge.net.au
Cc: luming.yu@gmail.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typo in per_cpu_offset
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030071513.GE5361@verge.net.au>
References: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com>
	<20071030071513.GE5361@verge.net.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Tue, 30 Oct 2007 16:15:13 +0900

> Though curiuously with my config nothing uses per_cpu_offset()
> (I added a bogus call to produce an error.) Is it actually
> used on ia64?

It is unused, and in that regard should probably be deleted.

include/asm-generic/percpu.h defines a seemingly similarly
unused per_cpu_offset() macro define as well
