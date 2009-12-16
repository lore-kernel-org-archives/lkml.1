Return-Path: <linux-kernel-owner+w=401wt.eu-S935112AbZLPSit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112AbZLPSit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935195AbZLPSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:38:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190AbZLPSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:35 -0500
Message-ID: <4B2928AC.3020807@zytor.com>
Date: Wed, 16 Dec 2009 10:36:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 16 (amd64_edac)
References: <20091216183212.118c5e14.sfr@canb.auug.org.au> <20091216092424.5f87214c.randy.dunlap@oracle.com> <4B2919BD.40001@zytor.com> <20091216174524.GH11618@aftab>
In-Reply-To: <20091216174524.GH11618@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:45 AM, Borislav Petkov wrote:
>>>
>>> Should EDAC_AMD64 also depend on SMP?
>>
>> That seems absurd... more likely msrs_free/msrs_alloc should not be
>> SMP-specific, or stubs need to be provided.
> 
> see <arch/x86/lib/Makefile>:
> 
> obj-$(CONFIG_SMP) := msr.o
> 

Yes, because the stubs live as inlines in arch/x86/include/asm/msr.h.

This needs to be fixed ASAP.

	-hpa
