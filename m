Return-Path: <linux-kernel-owner+w=401wt.eu-S1946091AbXEBAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946091AbXEBAAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946101AbXEBAAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:00:43 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25474 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946091AbXEBAAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:00:42 -0400
Date: Tue, 01 May 2007 17:59:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] support PCI MCFG space on Intel i915 bridges
In-reply-to: <200705011627.14948.jesse.barnes@intel.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <4637D456.3040303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no>
 <200704301225.22016.jesse.barnes@intel.com> <463679A4.60704@shaw.ca>
 <200705011627.14948.jesse.barnes@intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, April 30, 2007 4:20 pm Robert Hancock wrote:
>>> Right, but you patch should obsolete this stuff anyway.  I'll test
>>> it out in the next few days.
>> We likely still want this chipset-specific support, it will catch the
>> case where the MCFG table lists a location which is reserved in ACPI
>> but the chipset was actually programmed to a different location
>> entirely, which I seem to remember someone mentioning was actually
>> the case on some boards..
> 
> Yeah, I suppose that's true.  So maybe your new checking code should 
> leverage the stuff in mmconfig-shared.c to check against the register 
> values like Olivier mentioned?

The patch I sent takes the MCFG address from the chipset registers for 
known chipsets, or the ACPI MCFG table otherwise. Either way, it will 
verify that the memory range is reserved in ACPI.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

