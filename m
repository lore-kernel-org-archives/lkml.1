Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZE0WLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZE0WLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZE0WL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:11:29 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:58154 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbZE0WL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:11:28 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 18:11:28 EDT
Message-ID: <4A1DB855.2030608@firmworks.com>
Date: Thu, 28 May 2009 06:01:57 +0800
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
In-Reply-To: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If anybody is interested, the core ARM support has been added to the 
Open Firmware tree at svn://openfirmware.info/openfirmware - the same 
version of OFW that's used on OLPC - under an MIT-style license. This is 
a full-featured Open Firmware whose lineage traces back to the original 
Open Boot implementation that I wrote for Sun starting in 1987.

It's not yet fully elaborated for specific platforms and devices, but it 
does contain all the core IEE1275 device tree stuff and the standard 
support packages.  It gets you to an ok prompt on Beagle Board and 
Gumstix Overo systems.  The source-level and assembly-language debuggers 
are fully functional. As currently configured on those systems, you can 
load it into memory either via u-boot or instead of u-boot.

This base ARM port, while newly released as FOSS, is quite solid, having 
been developed some years ago for the Digital (RIP) DNARD system.

I'd be happy to work with people to add deeper support for specific 
device and platforms.
