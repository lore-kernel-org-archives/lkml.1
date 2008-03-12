Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbYCLM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbYCLM7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCLM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:59:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22617 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYCLM7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:59:16 -0400
Date: Wed, 12 Mar 2008 13:59:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080312125912.GM17940@kernel.dk>
References: <20080225200354.GE16513@khazad-dum.debian.net> <20080225204951.GB4432@ics.muni.cz> <20080225210113.GF16513@khazad-dum.debian.net> <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net> <20080226184937.GA4280@ics.muni.cz> <20080304194513.GY6704@kernel.dk> <47CDBA74.5080304@gmail.com> <20080304211212.GD6704@kernel.dk> <47CDBE11.4010900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDBE11.4010900@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05 2008, Alexey Starikovskiy wrote:
> Jens Axboe wrote:
> >On Wed, Mar 05 2008, Alexey Starikovskiy wrote:
> >  
> >>Jens Axboe wrote:
> >>    
> >>>On Tue, Feb 26 2008, Lukas Hejtmanek wrote:
> >>> 
> >>>      
> >>>>On Mon, Feb 25, 2008 at 08:00:35PM -0300, Henrique de Moraes Holschuh 
> >>>>wrote:
> >>>>   
> >>>>        
> >>>>>On Mon, 25 Feb 2008, Lukas Hejtmanek wrote:
> >>>>>     
> >>>>>          
> >>>>>>volume keys work. But anything through acpid does not. Even 
> >>>>>>AC/battery switch
> >>>>>>is not signalized. So the bug may be somewhere else?
> >>>>>>       
> >>>>>>            
> >>>>>Yeah, there is an EC-related regression in 2.6.25-rc3 that bites your
> >>>>>thinkpad.  I don't have a link to it right now, but if you look for the
> >>>>>messages to LKML on the last 48h, you will find it.
> >>>>>     
> >>>>>          
> >>>>this one fixes all my troubles with thinkpad hotkeys in rc3.
> >>>>http://lkml.org/lkml/2008/2/25/400
> >>>>   
> >>>>        
> >>>Ping - is anyone sending this upstream? Would be nice to have my x60
> >>>usable for -rc4 at least.
> >>>
> >>> 
> >>>      
> >>Please take a look at patches in #10100.
> >>    
> >
> >Can you be more specific (eg if you want me to test any/all of them, let
> >me know)?
> >
> >  
> Patch from comment #3 is in -mm at the moment, and has good chance to 
> appear in linus tree.
> I am trying to invent something less crufty along the lines of comment 
> #4, but not succeeded yet.

Updating and doing what the bugzilla entry suggests, that is reverting
the offending commit. That makes my brightness controls work, but the
volume and mute keys still do not work.

-- 
Jens Axboe

