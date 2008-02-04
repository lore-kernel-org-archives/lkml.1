Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYBDRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYBDRnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYBDRnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:43:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:53643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYBDRnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,303,1199692800"; 
   d="scan'208";a="295669127"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Mon, 4 Feb 2008 09:44:24 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE7830C7@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080203163255.467256d4.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Thread-Index: AchmxdTwADZMi/gIStWR895q+edGnwAj5Jww
References: <200801261506.28544.toralf.foerster@gmx.de> <20080203163255.467256d4.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: <linux-kernel@vger.kernel.org>, <cpufreq@www.linux.org.uk>
X-OriginalArrivalTime: 04 Feb 2008 17:43:12.0955 (UTC) FILETIME=[6A12B0B0:01C86755]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Andrew Morton
>Sent: Sunday, February 03, 2008 4:33 PM
>To: Toralf Förster
>Cc: linux-kernel@vger.kernel.org; cpufreq@www.linux.org.uk
>Subject: Re: (ondemand) CPU governor regression between 2.6.23 
>and 2.6.24
>
>On Sat, 26 Jan 2008 15:06:25 +0100 Toralf Förster 
><toralf.foerster@gmx.de> wrote:
>
>> I use a 1-liner for a simple performance check : "time 
>factor 819734028463158891"
>> Here is the result for the new (Gentoo) kernel 2.6.24:
>> 
>> With the  ondemand governor of the  I get:
>> 
>> tfoerste@n22 ~/tmp $ time factor 819734028463158891
>> 819734028463158891: 3 273244676154386297
>> 
>> real    0m32.997s
>> user    0m15.732s
>> sys     0m0.014s
>> 
>> With the ondemand governor the CPU runs at 600 MHz,
>> whereas with the performance governor I get :
>> 
>> tfoerste@n22 ~/tmp $ time factor 819734028463158891
>> 819734028463158891: 3 273244676154386297
>> 
>> real    0m10.893s
>> user    0m5.444s
>> sys     0m0.000s
>> 
>> (~5.5 sec as I expected) b/c the CPU is set to 1.7 GHz.
>> 
>> The ondeman governor of previous kernel versions however 
>automatically increased
>> the CPU speed from 600 MHz to 1.7 GHz.
>> 
>> My system is a ThinkPad T41, I'll attach the .config 
>> 
>

This looks like is related to the report here
http://www.ussg.iu.edu/hypermail/linux/kernel/0801.3/1260.html

Can you try the workarounds on that thread and see whether the problem goes away.

Thanks,
Venki
