Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYFPT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYFPT7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYFPT7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:59:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYFPT7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:59:00 -0400
Message-ID: <4856C5D5.7010800@zytor.com>
Date: Mon, 16 Jun 2008 12:58:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Paul Jackson <pj@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory
 ranges
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>	<1213600062.11185.13.camel@caritas-dev.intel.com>	<20080616032457.718f4d87.pj@sgi.com>	<1213606435.12968.14.camel@caritas-dev.intel.com>	<48568B56.7060307@zytor.com>	<20080616113806.2ff4c1a4.pj@sgi.com>	<48569D62.9050107@zytor.com>	<20080616123721.bb9195e6.pj@sgi.com>	<86802c440806161041v5f582d4y2a65adf57451a6d9@mail.gmail.com>	<20080616130938.527283f7.pj@sgi.com>	<4856AE64.7020906@zytor.com> <20080616195340.7d0a56a8@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616195340.7d0a56a8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>
>> 0x40E contains the pointer to the EBDA; this basically tests for the 
>> existence of an EBDA at all.
> 
> I'd disagree with the "very old". Machines without EBDA go right up to
> the AMD Athlon era and maybe beyond that. My old dual Athlon box has no
> EBDA.
> 

Fair enough.

	-hpa
