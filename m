Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbXHCSat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbXHCSat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXHCSam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:30:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:42803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbXHCSak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:30:40 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: 2.6.22 regression: thermal trip points
Date: Fri, 3 Aug 2007 14:30:26 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, trenn@suse.de,
       pavel@ucw.cz, mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org
References: <46B1988C.3090302@t-online.de> <200708021756.30776.lenb@kernel.org> <46B32561.5070703@t-online.de>
In-Reply-To: <46B32561.5070703@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031430.26789.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 08:53, Knut Petersen wrote:
> Len Brown :
> >  
> >
> > Thanks for the sighting, Knut!
> > This regression is dramatic when put in the terms of 50% performance hit!
> > I guess the good news is that thermal throttling is doing the job
> > we are asking it to:-)
> >
> >
> >   
> Thermal management by cpufreq is working really fine ;-)

Unfortunately, I a lot of people don't understand that the ";-)"
after this statement and they really think that cpufreq is a
solution for thermal management.  It isn't.  Systems still
need to be thermally sane when they are fully utilized and
cpufreq helps not.

> My problems are definitely not related to a linux bug. All trip_points
> are fixed, hardcoded in the system BIOS at address 0x000FF810.
> 
> Yes, I could hack  and flash a custom BIOS.
> 
> After reading a lot I think I even could fix the DSDT.

No, you should never have to override your BIOS --
except for debugging.

If Windows works out-of-the-box on this system,
then Linux should too - even if we have to use a DMI-based
workaround for a BIOS bug.

I'm looking forward to seeing the bug report that you are
going to file.  Please include the dmidecode output in addition
to the acpidump output.

thanks,
-Len
