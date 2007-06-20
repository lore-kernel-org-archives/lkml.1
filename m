Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbXFTWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbXFTWCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXFTWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:02:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXFTWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:02:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 21 Jun 2007 00:09:26 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, pavel@ucw.cz,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706192333.09183.rjw@sisk.pl>
In-Reply-To: <200706192333.09183.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706210009.27457.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 19 June 2007 23:33, Rafael J. Wysocki wrote:
> On Tuesday, 19 June 2007 13:18, Nigel Cunningham wrote:
> > Hi all
> > 
> > Here's what I have after today's work.
> > 
> > I haven't yet been able to test on x86, but can confirm that it works okay on
> > x86_64. I'm currently working towards testing it on my old Omnibook. My P4
> > desktop won't resume from suspend to ram at all, and hasn't produced any
> > beeps.   
> > 
> > I needed to move the BEEP invocation to after the data segment is reloaded,
> > so that the test could access the variable. That was pretty tricky to find -
> > no oops or anything bad prior, it just didn't beep when expected.  
> > 
> > A couple of notes:
> > 
> > - I'd like to put the BEEP macro somewhere that can be shared by x86 32 and
> > 64. If that's a good idea, any suggestions on where? Nothing occurs to me
> > straight off.  
> 
> I don't know either.  I think Andi is the right person to ask (CC added).
> 
> > - I've just switched from Evo to Kmail. Please let me know if there's any
> > mangling of the patch. 

Unfortunately, the message is encoded as "quoted printable" which results in
the whitespace being mangled.

> The patch looks good to me.  I'll try to run it on an i386 tomorrow.

I've recoded it and rediffed against -rc5 with the hibernation and suspend
patchset.  The resut is at

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/29-Optional-Beeping-During-Resume-From-RAM.patch

Well, my i386 test box doesn't seem to be able to beep at all.  I'll have to
look for another one ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
