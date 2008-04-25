Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbYDYTia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbYDYTia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYDYTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:38:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYDYTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:38:21 -0400
Message-ID: <48123325.30003@zytor.com>
Date: Fri, 25 Apr 2008 12:38:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org> <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com> <20080425192858.GM14990@parisc-linux.org>
In-Reply-To: <20080425192858.GM14990@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Apr 25, 2008 at 12:10:40PM -0700, H. Peter Anvin wrote:
>> Well, compatibility with userspace is probably one aspect of that. 
>> x86-64 is the odd man out there, it defines __s64 as "long long" even 
>> for userspace, even though int64_t from <stdint.h> is "long".  This, 
>> IMO, is the Wrong Thing, but it's a separate set of changes.
>>
>> The right thing to do is probably to always use "long long" in the 
>> kernel, while defining __s64 et al as "long" on 64-bit platforms when 
>> not under __KERNEL__.
>>
>> Again, this is a separate set of changes from this patchset, which is 
>> just a code transformation.
> 
> Understood, and agreed.  It just seemed like an opportune time to
> mention the problem of printing a u64.
> 

I have to admit to liking the Windows extension %I64u for this kind of 
stuff.  Unfortunately gcc/glibc decided to use I for internationalized 
digits instead :(

	-hpa
