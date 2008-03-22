Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYCVPEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYCVPEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYCVPEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:04:38 -0400
Received: from ns3.octant-fr.com ([91.121.71.136]:44042 "EHLO
	ns3.octant-fr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYCVPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:04:37 -0400
Message-ID: <47E51FEC.8010501@octant-fr.com>
Date: Sat, 22 Mar 2008 16:04:12 +0100
From: Tobias Oed <tobias.oed@octant-fr.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, matthew@wil.cx,
       Randy Dunlap <randy.dunlap@oracle.com>, tobias.oed@octant-fr.com
Subject: Re: 2.6.25-rc6 compile error in drivers/acpi/osl.c
References: <47E508B3.8070801@octant-fr.com> <47E51864.5000107@tremplin-utc.net>
In-Reply-To: <47E51864.5000107@tremplin-utc.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Piel wrote:
> (added Randy as CC just in case it ends up being a problem with 
> 7ce9573e093891f5807e6e50f3bd2012f1e5d0fe)
> Tobias Oed wrote:
>> Hello,
>> compiling 2.6.25-rc6 on my up to date fedora 8 system ends with
>>
>>   CC      drivers/acpi/osl.o
>> drivers/acpi/osl.c:60:38: error: n: No such file or directory
>> drivers/acpi/osl.c: In function ‘acpi_os_table_override’:
>> drivers/acpi/osl.c:334: error: ‘AmlCode’ undeclared (first use in this 
>> function)
>> drivers/acpi/osl.c:334: error: (Each undeclared identifier is reported 
>> only once
>> drivers/acpi/osl.c:334: error: for each function it appears in.)
>> make[2]: *** [drivers/acpi/osl.o] Error 1
>> make[1]: *** [drivers/acpi] Error 2
>> make: *** [drivers] Error 2
>>
>> Config attached
> Hi Tobias,
> First, you haven't sent the correct .config file (this one is dated "Fri 
> Mar 14 21:06:35 2008").

Oups, I took it from the wrong dir.

> To fix your problem you just need to "make menuconfig" and change 
> ACPI_CUSTOM_DSDT_FILE from "n" to "".
> 
> Now the question is: how did you end up with this error? Is it just you 
> who mistook while answering the questions of "make oldconfig" or did 
> this "n" appeared automatically because was not ACPI_CUSTOM_DSDT is set. 
> In which case this is a bug in the kernel.
> 
> Eric

I ran make oldconfig on my config for 2.6.25-rc5, and I answered n to 
the question

   Custom DSDT Table file to include (ACPI_CUSTOM_DSDT_FILE) [] (NEW)

Somehow not putting anything didn't seem right at the time. I see my 
error now.
Thanks for the quick answer and sorry for the noise.
Tobias Oed


-- 
*Tobias Oed* - Octant Informatique <http://www.octant-fr.com>
contact | tobias.oed@octant-fr.com <mailto:tobias.oed@octant-fr.com> -
04 76 50 82 38
image
