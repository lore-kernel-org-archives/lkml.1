Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbYEHAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbYEHAEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761205AbYEHAE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:04:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132AbYEHAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:04:28 -0400
Message-ID: <48224361.5080102@zytor.com>
Date: Wed, 07 May 2008 17:03:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl>
In-Reply-To: <48224318.8020209@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
>>
>> Okay, that is utter nonsense.  /proc/cpuinfo has always been, and will 
>> always be, the CPU *AS THE KERNEL SEES IT*.  If you want something 
>> else, use x86info(1).
> 
> What a lovely way of syncing reality with your definitions. The kernel
> _does_ see that my CPU features PAT, it just refuses to use it because
> it doesn't trust it enough. Vital difference. Maybe not to the kernel,
> but definitely to me, the user. /proc/cpuinfo is a user interface.
> 

No, /proc/cpuinfo is informing the user about the kernel's view of the 
CPU.  It has always been the "cooked" view of CPUID, whether or not you 
like it.

	-hpa
