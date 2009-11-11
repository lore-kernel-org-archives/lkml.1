Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZKKH6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZKKH6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZKKH6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:58:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbZKKH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:58:36 -0500
Message-ID: <4AFA6E71.70108@zytor.com>
Date: Tue, 10 Nov 2009 23:57:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl> <4AFA210B.3020207@kernel.org> <20091111074830.GA10310@elte.hu>
In-Reply-To: <20091111074830.GA10310@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 11:48 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
>>
>> to get area is below 1M
>>
>> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/acpi.h  |    2 +-
>>  arch/x86/kernel/acpi/sleep.c |   15 +++++++++------
>>  arch/x86/kernel/setup.c      |   13 +++++++------
>>  3 files changed, 17 insertions(+), 13 deletions(-)
> 
> Looks good. Rafael, Peter, does it look good to you too?
> 

Looks sane to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

