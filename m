Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYF1HWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYF1HWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 03:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYF1HWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 03:22:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:31813 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYF1HWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 03:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OfhuWPH0K4kabNJ2qbusr14a7hFTLukKs03Deg7TtPKCr1iwkzCCm9Dhv0o4Jj/KZU
         czrZEvepBxRnFv68pQB6b//a3vyForatJK6jQM/FgneqYxFrnQSHrIkiEqLymxty1XT3
         SA3pvHv+QpF1qi0MYOIUE+xoD6lZSBLjPxFBE=
Message-ID: <86802c440806280022l76ef93c4kd18c578cdaba421a@mail.gmail.com>
Date: Sat, 28 Jun 2008 00:22:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080628070243.GA31342@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806252151.29028.yhlu.kernel@gmail.com>
	 <200806271538.46829.yhlu.kernel@gmail.com>
	 <200806272247.11971.yhlu.kernel@gmail.com>
	 <20080628063500.GA15710@elte.hu> <20080628070243.GA31342@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > some end boundary is only page alignment, instead of 2M alignment, so
>> > call ker_phycial_mapping_init three times. then don't overmap above
>> > the max_low_pfn
>>
>> applied to tip/x86/unify-setup, thanks Yinghai.
>
> -tip testing found a 32-bit spontaneous reboot during bootup, with this
> config:
>
>  http://redhat.com/~mingo/misc/config-Sat_Jun_28_08_43_52_CEST_2008.bad
>
> no serial log produced at all.
even with console=uart8250,io,0x03f8,115200n8 ?

YH
