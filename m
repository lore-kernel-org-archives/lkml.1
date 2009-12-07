Return-Path: <linux-kernel-owner+w=401wt.eu-S935015AbZLGKRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbZLGKRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934999AbZLGKRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:17:16 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50739 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827AbZLGKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:17:15 -0500
X-IronPort-AV: E=Sophos;i="4.47,353,1257138000"; 
   d="scan'208";a="8451113"
Message-ID: <4B1CD62D.8000702@analog.com>
Date: Mon, 7 Dec 2009 18:17:17 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: David Howells <dhowells@redhat.com>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize
 	program header parsing
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 	<14959.1259948697@redhat.com> <4B19A92A.5030804@analog.com> <8bd0f97a0912070210m4f13e174y154fc82732ef136c@mail.gmail.com>
In-Reply-To: <8bd0f97a0912070210m4f13e174y154fc82732ef136c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2009 10:17:18.0018 (UTC) FILETIME=[747B4A20:01CA7726]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 06:10 PM, Mike Frysinger wrote:
> On Fri, Dec 4, 2009 at 19:28, Jie Zhang<wrote:
>> On 12/05/2009 01:44 AM, David Howells wrote:
>>> Mike Frysinger<vapier@gentoo.org>    wrote:
>>>> The Blackfin port has custom program header flags/addresses for
>>>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>>>> hook for ports to leverage.
>>>
>>> Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not
>>> against
>>> the general concept, but:
>>>
>>>> +               do_munmap(mm, *maddr, phdr->p_memsz + *disp);
>>>
>>> There needs to be a mapping covering the SRAM region for the purposes of
>>> the
>>
>> Our GDB is still lack of the feature to debug applications using SRAM.
>
> semi true.  L1 text appears to work fine:

This is by lucky. We need some feature in GDB 7.0 to cope with code or 
data in L1 SRAM.


Jie
