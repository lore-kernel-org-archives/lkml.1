Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZI2GeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZI2GeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZI2GeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:34:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:13795 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZI2GeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 02:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,471,1249282800"; 
   d="scan'208";a="192774516"
Message-ID: <4AC1AA61.8070408@intel.com>
Date: Tue, 29 Sep 2009 14:34:09 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com> <20090928211745.GA2119@elf.ucw.cz>
In-Reply-To: <20090928211745.GA2119@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-09-28 14:11:25, H. Peter Anvin wrote:
>> On 09/28/2009 02:07 PM, Rafael J. Wysocki wrote:
>>>> Well, I worry that S3 support for TXT makes TXT completely useless. A
>>>> little liquid nitrogen, remove RAM, place it in another machine,
>>>> modify it in any way you want, more liquid nitrogen, place it back.
>>>>
>>>> Oops, protection provided by TXT is lost.
>>> Ah, I see your point now.
>>>
>> Shane Wang sent me a patch for S3 support, but it missed the merge window:
>>
>> 	http://marc.info/?i=4A9CE0B2.5060608@intel.com
>>
>> *As far as I understand* -- and I haven't looked into it in detail yet,
>> having just come back from Plumber's -- this provides integrity
>> protection, not content extraction protection.
> 
> How does it provide integrity protection? I'm free to modify RAM
> content in the other machine....
> 									Pavel

Hi Pavel,

Before S3 sleep, tboot patch will MAC the memory, and after S3 resume, the 
memory integrity will be verified according to the MAC value. So, you can't 
modify RAM, or else you will fail on S3 resume.

The current patch hpa mentioned is for userspace memory integrity. For kernel 
memory integrity, the code is already in with the previous txt patch.

Thanks.
Shane
