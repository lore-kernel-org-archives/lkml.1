Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYIIRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYIIRp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYIIRpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:45:19 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55180 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbYIIRpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:45:18 -0400
Date: Tue, 9 Sep 2008 20:43:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909174333.GE30160@cs181140183.pp.htv.fi>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <20080909165728.GD30160@cs181140183.pp.htv.fi> <48C6AC79.3000003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48C6AC79.3000003@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 10:03:53AM -0700, H. Peter Anvin wrote:
> Adrian Bunk wrote:
>>
>> As far as I understood it it's a gas issue, and X86_GENERIC=y would  
>> therefore *not* fix the bug with gcc < 4.2 and affected binutils
>> since we pass -mtune=i686 for gcc < 4.2 with X86_GENERIC=y.
>>
>> Anything I miss?
>
> Well, for one thing, gcc doesn't actually pass the -mtune= option to  
> gas, it turns out.

What caused gas to emit the "wrong" NOPs?

> But yes, "-Wa,-march=generic32" is really the proper fix.

If I understand the binutils changelog correctly -march=generic32 
support was added one week before the NOP code in question, so all 
affected binutils versions support it.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

