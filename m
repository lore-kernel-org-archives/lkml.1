Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbXGLJrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbXGLJrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXGLJrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:47:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:13798 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbXGLJq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:46:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,531,1175497200"; 
   d="scan'208";a="249466136"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH][ACPI][BUTTON] remove procfs-interface
Date: Thu, 12 Jul 2007 17:46:52 +0800
Message-ID: <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <4695F726.7030203@nachtwindheim.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][ACPI][BUTTON] remove procfs-interface
Thread-Index: AcfEaKx81uSjo1oOTiSDgtSV0bg+BgAACIJQ
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Henne" <henne@nachtwindheim.de>, "Arjan van de Ven" <arjan@infradead.org>
Cc: "Brown, Len" <len.brown@intel.com>, <linux-acpi@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Jul 2007 09:46:57.0632 (UTC) FILETIME=[96582E00:01C7C469]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the ACPI sysfs conversion is not finished yet
and some user space tools still use the ACPI procfs.
The schedule of removing ACPI procfs I/F will be changed to Jan 08.
I'm about to send a patch to update it.

I'm not sure if the button sysfs I/F is already finished.
We'd better make a double check. :)

Thanks,
Rui

-----Original Message-----
From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Henne
Sent: 2007Äê7ÔÂ12ÈÕ 17:41
To: Arjan van de Ven
Cc: Brown, Len; linux-acpi@vger.kernel.org; akpm@linux-foundation.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ACPI][BUTTON] remove procfs-interface

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



-
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
