Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbYEFUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbYEFUcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYEFUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:31:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:11731 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbYEFUbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:31:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="561547986"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Date: Tue, 6 May 2008 13:34:22 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com>
In-Reply-To: <4820962B.6050702@numericable.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Thread-Index: Acivn61gv+BQ7YL5RYSqORyVWYmyUQAGK6ag
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 May 2008 20:31:47.0293 (UTC) FILETIME=[34B130D0:01C8AFB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>Sent: Tuesday, May 06, 2008 10:32 AM
>To: Ingo Molnar
>Cc: Pallipadi, Venkatesh; Siddha, Suresh B; Linux-kernel Mailing List
>Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>xf86MapVidMem error
>
>Ingo Molnar a écrit :
>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>
>>   
>>> Below is the patch to enable debug messages by a boot option 
>>> "debugpat".
>>>     
>Hi all,
>
>I have applied the patch from Ingo and I put my
>dmesg/syslog/messages/Xorg.log files in attached to help you 
>to identify
>the problem (two mails).
>
>Hope it can help you.
>

Did you use "debugpat" kernel boot option after applying Ingo's patch?
With Ingo's patch, that option is needed to print more info (Not needed with one line change I sent you yday).

Also, 'dmesg -s 256000' will not truncate the msg at 32K and will give bigger dmesg output.

Thanks,
Venki
