Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYIEOIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYIEOIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYIEOIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:08:12 -0400
Received: from wind.enjellic.com ([209.243.13.15]:42432 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYIEOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:08:11 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 10:08:11 EDT
Message-Id: <200809051336.m85DafdM019660@wind.enjellic.com>
From: greg@enjellic.com
Date: Fri, 5 Sep 2008 08:36:40 -0500
In-Reply-To: Jeff Dike <jdike@addtoit.com>
       "Re: Is SKAS still required for UML" (Aug 27,  3:06pm)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: Jeff Dike <jdike@addtoit.com>, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Is SKAS still required for UML
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 27,  3:06pm, Jeff Dike wrote:
} Subject: Re: Is SKAS still required for UML

Hi Jeff, hope the week is ending well for you.

> > I tried to put this to a test, and actually failed to modify the 
> > UML kernel/memory image from within it. I had a simple kernel module 
> > with 'int val = 2;' and upon loading this, done printk("Val is at %p\n", 
> > &val); to get to know the address. A userspace program inside the UML 
> > then tried to dereference that address and read the value, but that 
> > ended in a segfault. /proc/xxx/maps also does not show the UML kernel 
> > being mapped in any process inside the UML. Note that I was running in 
> > SKAS0 mode, both host and guest are all 64-bit. Is the NX bit of the 
> > 64-bit platform securing things off, or has SKAS3 become sort of 
> > obsolete?

> SKAS3 is still a significant performance boost.

Any thoughts or timetable on SKAS4 going mainline?  I suspect the
SKAS3 patches are even remotely compatible with current mainline
kernels.

We've had good success with SKAS4 on 2.6.24.x but thats even getting
awful long in the tooth at this point.  I've been meaning to try the
last copy of the SKAS4 patch against 2.6.26.x but haven't found the
time yet to wade through the flock of rejects which I would expect.

With all the renames in the impending 2.6.27 tree I'm afraid the
prospects are even worse.  The time seems ripe to push it towards
mainline.

>       	       		     Jeff

Thanks again for all your efforts on UML.

Have a good weekend.

}-- End of excerpt from Jeff Dike

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Atilla The Hun's Maxim: If you're going to rape, pillage and burn, be sure
 to do things in that order."
                                -- P.J. Plauger
                                   Programming On Purpose
