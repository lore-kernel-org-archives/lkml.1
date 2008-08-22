Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYHVRkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYHVRkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYHVRjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:39:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753661AbYHVRjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:39:51 -0400
Date: Fri, 22 Aug 2008 13:39:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
In-Reply-To: <200808222109.55358.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0808221333110.2230-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Andrey Borzenkov wrote:

> > > reverting 38b375d9610e2467cb793a84d17c6f65e44cdb39 fixed it
> > > 
> > 
> > ... that is:
> > 
> > commit 38b375d9610e2467cb793a84d17c6f65e44cdb39
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Mon Jul 21 09:56:26 2008 -0400
> > 
> >     USB: OHCI: fix system hang caused by earlier patch
> > 
> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >     Tested by: Andrey Borzenkov <arvidjaar@mail.ru>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > so it apparently used to work for you at that time.  What gives?
> > 
> 
> Well, you should not commit a fix without commiting code that has been
> fixed first :)

Actually the code to be fixed _was_ committed first -- but then it was 
reverted before the fix was accepted, so the fix was merged without it.

My advice is not to worry about it.  That code has been sent once again
to Linus -- it's not merged yet but presumably it will be soon.  
Certainly before 2.6.27-rc5 appears.

On the other hand, I still have to wonder how the fix could have caused
your problem without the original patch in place.  The fix itself
should have been totally innocuous.

Alan Stern

