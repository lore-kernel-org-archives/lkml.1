Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZJCO5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZJCO5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZJCO5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:57:00 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:32802 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZJCO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Os7zWLjnN3YZxuVQKaZ7WlXssZuxis9TKQqVsqfcN3LhdLU5JG/+raXul3yD8npu4/
         VkHPYKkkGSIxI+4ugOFP8oM2GHwXU7XaxW/k7++j6yTAu53KwPx1PBEv5lByLwl+QFIe
         r+QcmQNwvM/JGaytzahlWjeJo2As2ZfMMGCeM=
MIME-Version: 1.0
In-Reply-To: <4AC75BC5.6030207@zytor.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu> <40101cc30910030253w70adc454r1bb38ff4424c7b14@mail.gmail.com> 
	<4AC75BC5.6030207@zytor.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 3 Oct 2009 16:56:02 +0200
Message-ID: <40101cc30910030756x64308423kffe340be4dae4d6d@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 4:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/03/2009 02:53 AM, Matteo Croce wrote:
>>
>> Sorry Ingo but if you read my last mail I wrote that the GEODE does
>> supports FCOMI but not NOPL
>> so i don't know if it's worth it, even is I haven't ANY binary in my
>> system with such instruction:
>>
>> # find /lib/tls/i686 /lib/i686 -type f |xargs objdump -d |grep -c nopl
>> 0
>
> Recent gcc/binutils has been known to start to use them.
>
> Either way, it's a user-space-visible difference, so at least the kernel
> will not signal anything else based on existing precedent.

So it can't be applied, right?
