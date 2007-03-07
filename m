Return-Path: <linux-kernel-owner+w=401wt.eu-S1422753AbXCGRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422753AbXCGRLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXCGRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:11:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64724 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422748AbXCGRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:11:09 -0500
Date: Wed, 7 Mar 2007 09:07:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: NZG <ngustavson@emacinc.com>
Cc: Ben Nizette <ben.nizette@iinet.net.au>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: passing function pointers through platform devices?
Message-Id: <20070307090719.0bf99e3a.randy.dunlap@oracle.com>
In-Reply-To: <200703071037.00322.ngustavson@emacinc.com>
References: <200703061246.29615.ngustavson@emacinc.com>
	<45EE373B.80606@iinet.net.au>
	<200703071037.00322.ngustavson@emacinc.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 10:37:00 -0600 NZG wrote:

> > Once the generic GPIO framework migrates upstream from -mm
> Thank you,  but I've reorganized my system to pass platform resources to a 
> driver, which then registers simple gpio/pwm/quadencoder type devices as 
> standard classes declared in a subdirectory.  Specific methods are then 
> simple exported by stackable drivers.
> It's unlikely I will adopt the GPIO interface at this point unless they really 
> bring something new to the table.
> 
> I googled extensively and requested information on any current work here 
> before I began this project and got zip. (see forwarded email paste)
> 
> I also emailed Robert Schwebel directly and he told me to ask VGER as it was 
> being developed by someone else.
> 
> I don't mean to sound rude, but I really tried to build on existing work and 
> it wasn't made available, so I've gone my own way, I had not other choice.
> 
> P.S. Forgive my VGER newbness, but what is "-mm" ?

See http://kernel.org/patchtypes/mm.html:

"""
The -mm patches to the Linux kernel
The -mm patches are a set of patches, released by Andrew Morton, against the official kernel series. They are frequently more experimental in nature than the official series. These patches are available in Andrew's kernel directory:

    /pub/linux/kernel/people/akpm/
"""

> thx,
> NZG
> 
> > ----------  Forwarded Message  ----------
> >
> > Subject: GPIO device class driver
> > Date: Tuesday 20 February 2007 10:40 am
> > From: NZG <ngustavson@emacinc.com>
> > To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
> >
> > I am currently developing support for an ep9xx based SBC and want to export
> > it's GPIO through sysfs in a simple and standard way,
> > without adding yet another platform specific gpio driver to the kernel.
> >
> > As I understand it, a gpio class has already been begun by Robert Schwebel
> > in but has not as of yet become part of the mainstream kernel.
> >
> > Searching the archives for this yields no results since 2006.
> >
> > Can anyone point me to a current patch?
> > I'd like to start from there.
> >
> > thank you,
> > NZG
> >
> > -------------------------------------------------
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
