Return-Path: <linux-kernel-owner+w=401wt.eu-S965693AbXCGWOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbXCGWOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXCGWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:14:11 -0500
Received: from gw.goop.org ([64.81.55.164]:40196 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965693AbXCGWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:14:09 -0500
Message-ID: <45EF392F.5070101@goop.org>
Date: Wed, 07 Mar 2007 14:14:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com> <20070307155553.06c82ca1.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com> <20070307233833.f1482f86.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org> <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com> <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com> <45EF2DFF.4060209@goop.org> <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> You have the *choice* to do that:
>
> 1) You want standard delivery only:
>
>    - Just dont use signalfd
>
> 2) you want signalfd only:
>
>    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
>
> If you want both, you can have it. Race free.
>   

It's only usefully race-free if you are guarantee that each signal gets
delivered once, by one path or the other.  Otherwise you get a
non-deterministic number of each signal actually delivered - what
earthly use is that to an application?

    J
