Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXFOTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXFOTvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXFOTvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:51:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:3006 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbXFOTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ghhgMfZXKU3PQcrkqcixKaBzOlXfk502180l1v/TlXmSi+J6Mtb7o8HP3ysUvoocYv9u9DnxaVCVcEr5Wbh9ccKyix9nIpGw44h7eFqwSpmMmiNUUNpKcMK1l65ylaBwr0uudOLx0h6iPRqYp7RJZDLbgE8PTEUIlRB+VBjvhLY=
Date: Fri, 15 Jun 2007 23:49:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-ID: <20070615194914.GF8151@cvg>
References: <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr> <4672EC53.50409@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672EC53.50409@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Kok, Auke - Fri, Jun 15, 2007 at 12:45:23PM -0700]
| Jan Engelhardt wrote:
| >On Jun 15 2007 12:21, Kok, Auke wrote:
| >>Cyrill Gorcunov wrote:
| >>>[Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
| >>>| On Jun 15 2007 11:03, Randy Dunlap wrote:
| >>>| > > 
| >>>| > > "use tabs for indents and spaces for alignment"
| >>>| > > 
| >>>| > > If that means you need to use two dozen spaces, then so be it.
| >>>| >
| >>>| >I don't think that's what that rule means, but I didn't write it,
| >>>| >so I'm not absolutely sure about it.
| >>>| >
| >>>| >but we know that tab stops are every 8th character, not 4 :)
| >>>| 
| >>>| Hardly.
| >>>| 
| >>>Jan, as I see from CodingStyle:
| >>>
| >>> "Tabs are 8 characters, and thus indentations are also 8 characters."
| >>>
| >>>Actually it would be perfect to get strict rules also for math. and log.
| >>>operators being splitted on several lines:
| >>this doesn't say anything about alignment, which was his point :)
| >
| >Well tabs should _never_ be assumed to be 8, and in this regard, as I 
| >see it, CodingStyle has a bug. Tabs are there so that the user can set 
| >their width according to _their_ taste, simply so that both sides,
| >
| >	from CodingStyle:
| >	Tabs are 8 characters, and thus indentations are also 8
| >	characters.  There are heretic movements that try to make
| >	indentations 4 (or even 2!) characters deep, and that is akin
| >	to trying to define the value of PI to be 3.
| 
| again, this is about *indentation* and not about alignment
| 
| >Linus (did he wrote that part?) and the heretics both can have their fun 
| >without impacting each other. If we wanted to force the user to have 
| >exactly 8 screen blanks, we should use spaces throughout.
| 
| Linus was friendly enough to give us permission to use tabs. He forces tabs 
| for indentation, but leaves it up to everyone else to (1) set their editor 
| to show tabs as 2 or 4 or whatever, and (2) use spaces for alignment.
| 
| the bottom line here is that we encourage everyone to use tabs=8, and allow 
| some degree of freedom for some people to vary this *AND* have decent 
| looking alignment for *EVERYONE* by allowing them to use spaces for 
| alignment.
| 
| Nothing in the codingstyle document confirms or denies this, so I will 
| assume that it is _allowed_ to use spaces for alignment.
		^^^^^^^^^^^^^^^
Actually that is exactly what I was expecting to see. Thanks a lot.

| 
| the checkpatch.pl script doesn't disallow spaces for alignment - it is dumb 
| enough to complain about more than 8 spaces for alignment.
| 
| That is and was the whole point... and worth the addition to CodingStyle 
| for me
| 
| 
| Auke
| 


		Cyrill

