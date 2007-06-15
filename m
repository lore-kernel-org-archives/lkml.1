Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbXFOUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbXFOUk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXFOUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:40:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbXFOUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:40:11 -0400
Date: Fri, 15 Jun 2007 13:39:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
In-Reply-To: <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <20070615194140.GE8151@cvg>
 <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Jan Engelhardt wrote:
> 
> Linux maintainers will enforce \t "being"[1] 8, and will also enforce
> the 80-column limit[2].

Heh. Actually, Linux maintainers have generally very consciously _avoided_ 
trying to "enforce" coding style issues.

We encourage. Sometimes people actually end up running "lindent" on code 
and enforce the rules through that, but that is actually fairly rare, and 
most of the time that happens only when somebody decides to tackle some 
subsystem that hasn't effectively been maintained in a while, and in order 
to do cleanups, the person needs to just make it readable first.

Is that the _onbly_ case when we do that? No. There's the occasional 
Lindent run done randomly, usually brought on by something _really_ 
atrocious, but I would say that generally we try to keep code churn due to 
_just_ coding style issues to a minimum.

I do sometimes end up not taking *new* code if it is really really ugly. 
So it definitely happens. But...

			Linus

