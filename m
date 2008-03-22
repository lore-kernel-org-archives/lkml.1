Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYCVOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYCVOcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYCVOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:32:13 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:4706 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbYCVOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:32:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47E51864.5000107@tremplin-utc.net>
Date: Sat, 22 Mar 2008 15:32:04 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Tobias Oed <tobias.oed@octant-fr.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, matthew@wil.cx,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc6 compile error in drivers/acpi/osl.c
References: <47E508B3.8070801@octant-fr.com>
In-Reply-To: <47E508B3.8070801@octant-fr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added Randy as CC just in case it ends up being a problem with 
7ce9573e093891f5807e6e50f3bd2012f1e5d0fe)
Tobias Oed wrote:
> Hello,
> compiling 2.6.25-rc6 on my up to date fedora 8 system ends with
> 
>   CC      drivers/acpi/osl.o
> drivers/acpi/osl.c:60:38: error: n: No such file or directory
> drivers/acpi/osl.c: In function ‘acpi_os_table_override’:
> drivers/acpi/osl.c:334: error: ‘AmlCode’ undeclared (first use in this 
> function)
> drivers/acpi/osl.c:334: error: (Each undeclared identifier is reported 
> only once
> drivers/acpi/osl.c:334: error: for each function it appears in.)
> make[2]: *** [drivers/acpi/osl.o] Error 1
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2
> 
> Config attached
Hi Tobias,
First, you haven't sent the correct .config file (this one is dated "Fri 
Mar 14 21:06:35 2008").

To fix your problem you just need to "make menuconfig" and change 
ACPI_CUSTOM_DSDT_FILE from "n" to "".

Now the question is: how did you end up with this error? Is it just you 
who mistook while answering the questions of "make oldconfig" or did 
this "n" appeared automatically because was not ACPI_CUSTOM_DSDT is set. 
In which case this is a bug in the kernel.

Eric
