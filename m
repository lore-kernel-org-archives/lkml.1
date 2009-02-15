Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZBOS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZBOS3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZBOS3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:29:22 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:53123 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbZBOS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:29:21 -0500
Message-ID: <49985F19.3040508@oracle.com>
Date: Sun, 15 Feb 2009 10:29:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] docbook: split kernel-api, add device-drivers book
References: <20090211162644.f3feb758.randy.dunlap@oracle.com> <20090215093014.GD29094@uranus.ravnborg.org>
In-Reply-To: <20090215093014.GD29094@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.49985EF2.00C4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Feb 11, 2009 at 04:26:44PM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> The kernel-api docbook was much larger than any of the others,
>> so processing it took longer and needed some docbook extras in
>> some cases, so split it into kernel-api (infrastructure etc.)
>> and device drivers/device subsystems.  This allows these docbooks
>> to be generated in parallel.  (This reduced the docbook processing
>> time on my 4-proc system with make -j4 from about 5min:16sec to
>> about 2min:01sec.)
>>
>> The chapters that were moved from kernel-api to device-drivers are:
>>
>> Driver Basics
>> Device drivers infrastructure
>> Parallel Port Devices
>> Message-based devices
>> Sound Devices
>> 16x50 UART Driver
>> Frame Buffer Library
>> Input Subsystem
>> Serial Peripheral Interface (SPI)
>> I2C and SMBus Subsystem
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I like the split, and I assume you will carry the patch in a Documentation tree?
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

If I need to :)

or Andrew can merge it.

-- 
~Randy
