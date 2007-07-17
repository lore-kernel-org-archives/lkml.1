Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbXGQOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbXGQOjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbXGQOja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:39:30 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:32140 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbXGQOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:39:27 -0400
Date: Tue, 17 Jul 2007 08:39:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
In-reply-to: <fa.+iOE+OqrQUbecN788fV4aEhLLtg@ifi.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
Message-id: <469CD4B8.9070506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.IMXKKgfBkv/U+MG0xx5sLkpV2Ws@ifi.uio.no>
 <fa.+iOE+OqrQUbecN788fV4aEhLLtg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
>> Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
> 
> Why? I had such a patch at some point as experiment, but it never
> helped actually fix a box.

Depends if Windows resets using this method, in that case using it as 
well would likely prevent the steady trickle of machines that seem to 
have trouble with other reset methods and need blacklist entries..

I sometimes think that with these sorts of things where basic 
functionality like reboot is broken, people are too quick to put in 
hacks to make it work and nobody looks into why it works consistently in 
Windows but not in Linux and what we are doing differently..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

