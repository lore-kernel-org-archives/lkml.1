Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbZFOSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbZFOSaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZFOSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:30:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761150AbZFOSaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:30:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jX6mRqBP8Swq/hh/OlwUDJ3Qk8JpWi9w6BlSqo3gZt+mTun6MPvNVw3DYF1lw/WnH
	ruLan2YamkxLknmPJL0fw==
MIME-Version: 1.0
In-Reply-To: <20090615132018.GA14555@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <1245033557-10968-3-git-send-email-swetland@google.com>
	 <20090615132018.GA14555@elf.ucw.cz>
Date: Mon, 15 Jun 2009 11:30:11 -0700
Message-ID: <a55d774e0906151130x3892346fx5aa1f62c387b2090@mail.gmail.com>
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL) 
	configurable
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 6:20 AM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> Signed-off-by: Brian Swetland <swetland@google.com>
>> ---
>>  arch/arm/mach-msm/Kconfig                    |   24 ++++++++++++++++++++++++
>>  arch/arm/mach-msm/include/mach/debug-macro.S |   25 ++++++++++++++++++-------
>>  arch/arm/mach-msm/include/mach/msm_iomap.h   |   12 ++++++++++++
>>  arch/arm/mach-msm/include/mach/uncompress.h  |    7 +++++++
>>  arch/arm/mach-msm/io.c                       |    3 +++
>>  5 files changed, 64 insertions(+), 7 deletions(-)
>
> I'm not sure if this is appropriate for mainline at this point. It
> seems like few people have debug cable at this point...
>
>> +config MSM_DEBUG_UART
>> +     int
>> +     default 1 if MSM_DEBUG_UART1
>> +     default 2 if MSM_DEBUG_UART2
>> +     default 3 if MSM_DEBUG_UART3
>
> ...and those that do, have it at fixed uart, no?

Well, I'd like to support the SoC generally, not just Dream -- it's
used in a bunch of different devices, and there's nothing that forces
you to use UART3 everywhere (I certainly have seen some 7k hardware
that uses UART1 as the debug serial port).

Brian
