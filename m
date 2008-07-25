Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYGYPD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYGYPD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYGYPDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:03:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:38266 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYGYPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DpCLpZ0hh/UYC/6HKhjRZsl1RdArOYpn1mHgye3Rp8gKooHheyP0XbBHLVY7xiYtb1
         cH15DVV3cViKcKENF9+PYuIyABVRAvVrfD/Lqo32l6y5fHn6ph4iTUGmmLtjPQ7JSol8
         IqOnhIvBukctd1iNiOjBHaBoW/4Ax2roUpkK4=
Message-ID: <19f34abd0807250803y2992aff8g369ce7f6b802708@mail.gmail.com>
Date: Fri, 25 Jul 2008 17:03:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel BUG in 2.6.26-git series
Cc: LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <4889E538.5010007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4889E538.5010007@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 4:37 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In the current git pulls from Linus's tree, I get a kernel BUG if
> CONFIG_SCHED_SMT is defined. It does not always appear, but when it does, it
> is late in the bootup sequence. Perhaps there is a timing issue. This is an
> x86_64 system on an HP dv2815nr notebook with and AMD Turion X2 CPU. My
> distro is openSUSE 11.0.
>
> kernel: BUG: unable to handle kernel NULL pointer dereference at
> 000000000000002
> kernel: IP: [<ffffffff80231aec>] sched_mc_power_savings_store+0x13/0x41

Maybe LKML is slow and somebody else replied to this before me, but I
know how much I hate to discover that I've been bisecting something
that was fixed a week ago in another tree, so here's a link you might
try :-)

http://lkml.org/lkml/2008/7/24/398


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
