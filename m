Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbXGLJk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbXGLJk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbXGLJkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:40:19 -0400
Received: from server78.greatnet.de ([83.133.96.102]:44640 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXGLJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:40:17 -0400
Message-ID: <4695F726.7030203@nachtwindheim.de>
Date: Thu, 12 Jul 2007 11:40:54 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: len.brown@intel.com, linux-acpi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ACPI][BUTTON] remove procfs-interface
References: <4695ED3F.7020303@nachtwindheim.de> <1184230838.2720.5.camel@laptopd505.fenrus.org>
In-Reply-To: <1184230838.2720.5.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> On Thu, 2007-07-12 at 10:58 +0200, Henne wrote:
>   
>> Removes the proc_fs interface from the ACPI button driver.
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>>
>> ---
>>     
>
> you forgot to say why.....
>
>
>   
First, because refering to /Documentation/feature-removal-schedule.txt it should be done:

>What:   /proc/acpi/button
>When:   August 2007
>Why:    /proc/acpi/button has been replaced by events to the input layer
>        since 2.6.20.
>Who:    Len Brown <len.brown@intel.com>

Second, refering to /Documentation/feature-removal-schedule.txt
 
>What:   ACPI procfs interface
>When:   July 2007
>Why:    After ACPI sysfs conversion, ACPI attributes will be duplicated
>        in sysfs and the ACPI procfs interface should be removed.
>Who:    Zhang Rui <rui.zhang@intel.com>

The button driver uses acpi_root_dir which won't be available if acpi is removed this month.
That would lead to errors, I think.



