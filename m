Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZI1VMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZI1VMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZI1VMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:12:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZI1VMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:12:32 -0400
Message-ID: <4AC1267D.6020405@zytor.com>
Date: Mon, 28 Sep 2009 14:11:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl>
In-Reply-To: <200909282307.56190.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 02:07 PM, Rafael J. Wysocki wrote:
>>
>> Well, I worry that S3 support for TXT makes TXT completely useless. A
>> little liquid nitrogen, remove RAM, place it in another machine,
>> modify it in any way you want, more liquid nitrogen, place it back.
>>
>> Oops, protection provided by TXT is lost.
> 
> Ah, I see your point now.
> 

Shane Wang sent me a patch for S3 support, but it missed the merge window:

	http://marc.info/?i=4A9CE0B2.5060608@intel.com

*As far as I understand* -- and I haven't looked into it in detail yet,
having just come back from Plumber's -- this provides integrity
protection, not content extraction protection.

Shane, could you please comment?

Thanks,

	-hpa
