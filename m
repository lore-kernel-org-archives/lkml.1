Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbYJISpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbYJISpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJISpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:45:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJISo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:44:59 -0400
Message-ID: <48EE50EE.4070505@zytor.com>
Date: Thu, 09 Oct 2008 11:43:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>	 <20080930165739.7847be37.rdunlap@xenotime.net>	 <20081008170751.6d86b8e2.rdunlap@xenotime.net>	 <86802c440810081828m2b9210e6y81503bdffe12fb03@mail.gmail.com>	 <20081009102049.c22cf670.rdunlap@xenotime.net> <86802c440810091108w706c5382p6a7b283ba2ebe2b1@mail.gmail.com>
In-Reply-To: <86802c440810091108w706c5382p6a7b283ba2ebe2b1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>> like to filter out disable, enable, no, etc...
>> I don't think that mtrr gets any special treatment here.
>> All "acpi" parameters are not grouped together (unless they begin with
>> "acpi").  All "apic" parameters are not grouped together.
>> All "*iommu*" parameters are not grouped together....
> 
> could adjust acpi iommu to same layout
> 

I think the point is that it shouldn't be...

	-hpa
