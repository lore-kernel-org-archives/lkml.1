Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYHVRAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYHVRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYHVRAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:00:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYHVRAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:00:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
Date: Fri, 22 Aug 2008 19:04:03 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200808222026.25944.arvidjaar@mail.ru> <200808222053.09066.arvidjaar@mail.ru>
In-Reply-To: <200808222053.09066.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221904.04773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Andrey Borzenkov wrote:
> On Friday 22 August 2008, Andrey Borzenkov wrote:
> > 
> > 2.6.26-rc3 is OK

Thanks for the report, but ...
 
> > top - 20:11:08 up 5 min,  1 user,  load average: 7.05, 4.50, 1.93
> > Tasks: 103 total,   3 running, 100 sleeping,   0 stopped,   0 zombie
> > Cpu(s):  8.3%us, 91.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > Mem:    494172k total,   278192k used,   215980k free,    18264k buffers
> > Swap:   500432k total,        0k used,   500432k free,   159376k cached
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >   851 root      15  -5     0    0    0 R 65.6  0.0   3:21.16 khubd
> 
> reverting 38b375d9610e2467cb793a84d17c6f65e44cdb39 fixed it
> 

... that is:

commit 38b375d9610e2467cb793a84d17c6f65e44cdb39
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Jul 21 09:56:26 2008 -0400

    USB: OHCI: fix system hang caused by earlier patch

    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Tested by: Andrey Borzenkov <arvidjaar@mail.ru>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

so it apparently used to work for you at that time.  What gives?

Rafael
