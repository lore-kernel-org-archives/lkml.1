Return-Path: <linux-kernel-owner+w=401wt.eu-S934156AbXHHKWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156AbXHHKWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXHHKVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:21:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41642
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbXHHKVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:21:31 -0400
Date: Wed, 08 Aug 2007 03:21:31 -0700 (PDT)
Message-Id: <20070808.032131.35507346.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au
Subject: Re: [patch] ipvs: force read of atomic_t in while loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070808093300.GA14530@osiris.boeblingen.de.ibm.com>
References: <20070808093300.GA14530@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 8 Aug 2007 11:33:00 +0200

> Just saw this while grepping for atomic_reads in a while loops.
> Maybe we should re-add the volatile to atomic_t. Not sure.

I think whatever the choice, it should be done consistently
on every architecture.

It's just asking for trouble if your arch does it differently from
every other.
