Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZJ3Iiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZJ3Iiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZJ3Iiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:38:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57238
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbZJ3Iit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:38:49 -0400
Date: Fri, 30 Oct 2009 01:39:13 -0700 (PDT)
Message-Id: <20091030.013913.238587076.davem@davemloft.net>
To: Martin@lichtvoll.de
Cc: linux-kernel@vger.kernel.org, hancockrwd@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910300918.39261.Martin@lichtvoll.de>
References: <20091029.173028.248393897.davem@davemloft.net>
	<200910300915.51836.Martin@lichtvoll.de>
	<200910300918.39261.Martin@lichtvoll.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Fri, 30 Oct 2009 09:18:39 +0100

> One thing to add: If you use a InitRD, you can use UUID or LABEL in GRUB 1 
> as well. I believe GRUB 2 at leasts supports UUID out of the box, but 
> better check this, before relying on my word.

Since I recently implement sparc64 support for GRUB2 I know that
indeed it does support UUID out of the box.

But grub2 sparc64 support is very new and the existing sparc64 boot
loader 'SILO' doesn't support UUIDs.

Personally, I also don't use initrds, I avoid them like the
plague. :-)
