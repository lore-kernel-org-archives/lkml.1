Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403Ab0ANHsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0ANHsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080Ab0ANHsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:48:53 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:57311 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab0ANHsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:48:53 -0500
Message-ID: <4B4ECC41.3080104@pardus.org.tr>
Date: Thu, 14 Jan 2010 09:48:17 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4EC0A1.3090503@pardus.org.tr> <4B4ECB1C.6070000@kernel.org>
In-Reply-To: <4B4ECB1C.6070000@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote On 14-01-2010 09:43:
> On 01/13/2010 10:58 PM, Ozan Çağlayan wrote:
>> Ozan Çağlayan wrote On 13-01-2010 20:51:
>>

>>
>> The users all have an AMD Athlon XP series processor. There are 576 changes in arch/x86/kernel and 291
>> in arch/x86/kernel/cpu between 2.6.30 and 2.6.31. Need some hands where to start to debug the problem.
> 
> can you just deselect CONFIG_X86_CPU_DEBUG in your .config ?

I just made that and waiting for feedback from the users as I can't find an Athlon XP. If it correctly boots, I'll disable
that temporarily until we bisect it.



