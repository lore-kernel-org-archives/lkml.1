Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXCGWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXCGWWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030522AbXCGWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:22:51 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42778 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXCGWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:22:50 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 14:21:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <45EF392F.5070101@goop.org>
Message-ID: <Pine.LNX.4.64.0703071419160.4893@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
 <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
 <45EF2DFF.4060209@goop.org> <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
 <45EF392F.5070101@goop.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Jeremy Fitzhardinge wrote:

> Davide Libenzi wrote:
> > You have the *choice* to do that:
> >
> > 1) You want standard delivery only:
> >
> >    - Just dont use signalfd
> >
> > 2) you want signalfd only:
> >
> >    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
> >
> > If you want both, you can have it. Race free.
> >   
> 
> It's only usefully race-free if you are guarantee that each signal gets
> delivered once, by one path or the other.  Otherwise you get a
> non-deterministic number of each signal actually delivered - what
> earthly use is that to an application?

As I mentioned above, you do have the option to do that. With basically 
the same kernel-side code. I mean, I could add a flag to signalfd and do 
the blocking inside there, but that's just pushing stuff into the call.



- Davide


