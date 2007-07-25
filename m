Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbXGYT2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbXGYT2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761083AbXGYT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:28:41 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40339
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759659AbXGYT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:28:40 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Wed, 25 Jul 2007 15:28:35 -0400
User-Agent: KMail/1.9.6
Cc: Bodo Eggert <7eggert@gmx.de>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, Rod Whitby <rod@whitby.id.au>,
       Russell King <rmk@arm.linux.org.uk>, david@lang.hm
References: <8I2t1-7jt-5@gated-at.bofh.it> <E1ICDr7-0000e9-P4@be1.lrz> <20070724063818.GB31806@kroah.com>
In-Reply-To: <20070724063818.GB31806@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251528.36130.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 2:38:18 am Greg KH wrote:
> > In other words: Grasping sysfs is not a feasible task? If this is true,
> > how can anybody reliably use sysfs?
>
> Huh, I never stated that at all.  If you wish to fully document sysfs
> and how it works, then great, do that.  But that was not the stated
> intent of this document, and is why I think the author got confused as
> he was attempting to put a narrow portion of how sysfs works as a
> reflection on how the whole of the body works.

I am often confused.  Confusion is my natural state.  It's how I got started 
writing documentation, as "notes to me" so I'd be able to reproduce what I 
did.

Currently my "one more thing to research before I can write this up" is your 
earlier comment that I can coldplug the existing set of devices without 
talking to sysfs.  Possibly there's a way to do this through netlink, but I 
don't know of any way to send data _back_ to the kernel with the usermode 
helper mechanism, and telling the kernel to do that for every device in the 
system at once seems like a fork bomb waiting to happen anyway.

Yes, some embedded developers want to remove the networking layer from the 
kernel, meaning they can't use netlink, meaning if we ever _do_ go to 
dynamically allocated /dev nodes and you _must_ populate /dev by getting the 
numbers out of the kernel, this is an issue.

So far, I've been able to devote about 15 minutes to this topic since the 
weekend, and that was stolen from something else...

> thanks,
>
> greg k-h

Rob

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
