Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXFOTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXFOTng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXFOTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:43:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:55902 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXFOTn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YaESRXbK2YyKa4JtqK03FCV3Y3UyHqxAx2tixJP6zQmpwVtkv5bBoUL0rpaw65Fj5ab0OKIcR2oEFP0KqWwk1RAeYHc09wq0GKALfqYRmaWC5uUxnJ8lGgsjf1X/e25+/kfLC0llBpiBcilY4NFDHTui3nVR3eo2G83w0sAF4hw=
Date: Fri, 15 Jun 2007 23:41:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: coding style
Message-ID: <20070615194140.GE8151@cvg>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Fri, Jun 15, 2007 at 09:31:27PM +0200]
| 
| On Jun 15 2007 12:21, Kok, Auke wrote:
| > Cyrill Gorcunov wrote:
| >> [Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
| >> | On Jun 15 2007 11:03, Randy Dunlap wrote:
| >> | > > 
| >> | > > "use tabs for indents and spaces for alignment"
| >> | > > 
| >> | > > If that means you need to use two dozen spaces, then so be it.
| >> | >
| >> | >I don't think that's what that rule means, but I didn't write it,
| >> | >so I'm not absolutely sure about it.
| >> | >
| >> | >but we know that tab stops are every 8th character, not 4 :)
| >> | 
| >> | Hardly.
| >> | 
| >> Jan, as I see from CodingStyle:
| >> 
| >>  "Tabs are 8 characters, and thus indentations are also 8 characters."
| >> 
| >> Actually it would be perfect to get strict rules also for math. and log.
| >> operators being splitted on several lines:
| >
| > this doesn't say anything about alignment, which was his point :)
| 
| Well tabs should _never_ be assumed to be 8, and in this regard, as I 
| see it, CodingStyle has a bug. Tabs are there so that the user can set 
| their width according to _their_ taste, simply so that both sides,
| 
| 	from CodingStyle:
| 	Tabs are 8 characters, and thus indentations are also 8
| 	characters.  There are heretic movements that try to make
| 	indentations 4 (or even 2!) characters deep, and that is akin
| 	to trying to define the value of PI to be 3.
| 
| Linus (did he wrote that part?) and the heretics both can have their fun 
| without impacting each other. If we wanted to force the user to have 
| exactly 8 screen blanks, we should use spaces throughout.
| 
| (And BTW,  int pi = 3.141592 _is_ going to be 3 ;-) and floating point 
| is mostly an agreed no-go in kernel anyway, even if it's supported.)
| 
| 
| 
| 	Jan
| -- 
| 

Dunno who wrote that part :(. Jan, look:

	Now, some people will claim that having 8-character indentations makes
	the code move too far to the right, and makes it hard to read on a
	80-character terminal screen.  The answer to that is that if you need
	more than 3 levels of indentation, you're screwed anyway, and should fix
	your program.

your opinion? Is it a bug too? Don't get me wrong I'm just trying to clarify
coding style.

		Cyrill

