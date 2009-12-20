Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZLTVHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZLTVHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZLTVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:06:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZLTVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:06:57 -0500
Date: Sun, 20 Dec 2009 22:06:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/2] SYSCTL: Make bin_table not const
Message-ID: <20091220210650.GA5143@basil.fritz.box>
References: <20091219358.549678091@firstfloor.org> <20091219145832.A0424B158A@basil.firstfloor.org> <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain> <20091219211831.GA19716@basil.fritz.box> <m1d429o1g5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d429o1g5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is printk_ratelimit truly ineffective at what it does?
> 
> Arguably we don't need to warn anywhere near that often, so even
> if printk_ratelimit works we are good.
> 
> If printk_ratelimit let's too much through we really should also write
> a patch to let fewer messages through that way.

Any time based rate is too much for compatibility. Assume even if you only 
printed one per hour and the user keeps running a program that 
uses sysctl it would still be >5000 messages each month.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
