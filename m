Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbZJCOMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbZJCOMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZJCOM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:12:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZJCOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:12:28 -0400
Message-ID: <4AC75BC5.6030207@zytor.com>
Date: Sat, 03 Oct 2009 07:12:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matteo Croce <technoboy85@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 	<20091003072127.GC21407@elte.hu> <40101cc30910030253w70adc454r1bb38ff4424c7b14@mail.gmail.com>
In-Reply-To: <40101cc30910030253w70adc454r1bb38ff4424c7b14@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2009 02:53 AM, Matteo Croce wrote:
> 
> Sorry Ingo but if you read my last mail I wrote that the GEODE does
> supports FCOMI but not NOPL
> so i don't know if it's worth it, even is I haven't ANY binary in my
> system with such instruction:
> 
> # find /lib/tls/i686 /lib/i686 -type f |xargs objdump -d |grep -c nopl
> 0

Recent gcc/binutils has been known to start to use them.

Either way, it's a user-space-visible difference, so at least the kernel
will not signal anything else based on existing precedent.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

