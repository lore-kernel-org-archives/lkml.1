Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbZKLHIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbZKLHIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZKLHIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:08:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZKLHIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:08:41 -0500
Message-ID: <4AFBB45A.9000606@zytor.com>
Date: Wed, 11 Nov 2009 23:08:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com> <20091112065930.GA9279@elte.hu>
In-Reply-To: <20091112065930.GA9279@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 10:59 PM, Ingo Molnar wrote:
> 
> * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
>> "ht" flag indicates only ability to detect siblings not HT presence 
>> itself.
>>
>> Inspired by:
>> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
> 
> i think instead of changing 'ht' to 'ht_detect', it would be even more 
> intuitive to only expose the 'ht' flag if the ht-detect capability is 
> there _and_ if the number of siblings is 2 or more.
> 
> That way we dont change it - we just 'hide' the 'ht' string on the 
> category of systems that can enumerate HT via the CPUID but dont 
> actually have HyperThreading.
> 

/proc/cpuinfo is a user-space visible ABI.  Changing it is bad chicken.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

