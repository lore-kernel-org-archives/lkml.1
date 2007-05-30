Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbXE3Xcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbXE3Xcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbXE3XcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:32:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:30237 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbXE3XcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:32:14 -0400
Date: Wed, 30 May 2007 17:31:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 0/2: PCI MMCONFIG-related updates
In-reply-to: <200705300821.11555.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <465E0968.90707@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <465CF712.2010604@shaw.ca>
 <200705300821.11555.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, May 29, 2007 9:01:22 Robert Hancock wrote:
>> These two patches implement some changes in behavior related to PCI
>> MMCONFIG configuration space access. One changes the way in which we
>> validate the MCFG table provided by the BIOS by checking it against
>> ACPI motherboard resources instead of the E820 table. The BIOS is not
>> required to reserve this area in the E820 table, so checking that
>> results in MMCONFIG being unnecessarily disabled on some machines.
>>
>> Some Intel chipsets where MMCONFIG was being disabled previously
>> (but won't be with the first patch) had problems, not due to the
>> MCFG table being broken, but because the access was hosed by the way
>> in which we do PCI BAR sizing. The second patch fixes this problem.
>>
>> This is requested for inclusion in the -mm tree for testing.
> 
> Robert, should we also pull in the 915 and 965 chipset specific register 
> poking code?  It might be a good sanity check against ACPI (i.e. if ACPI and 
> the actual register window disagree, we can assume the BIOS is broken and 
> MCFG is not safe to use).  If so, I'll update and repost them against your 
> patchset.

Probably not a bad idea..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

