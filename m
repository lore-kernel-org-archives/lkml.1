Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXF1LyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXF1LyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759564AbXF1LyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:54:13 -0400
Received: from smtpout.mac.com ([17.250.248.183]:56776 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581AbXF1LyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:54:12 -0400
In-Reply-To: <20070628035754.GB22063@parisc-linux.org>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <20070628035754.GB22063@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6B8385EC-8CD4-4E8B-94EF-293A02A62189@mac.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       Andi Kleen <ak@suse.de>, linux-arch@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 07:53:51 -0400
To: Matthew Wilcox <matthew@wil.cx>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27, 2007, at 23:57:54, Matthew Wilcox wrote:
> On Wed, Jun 27, 2007 at 06:30:52PM -0400, Kyle Moffett wrote:
>> Then all 64-bit archs have:
>> typedef   signed long      __s64;
>> typedef unsigned long      __u64;
>>
>> While all 32-bit archs have:
>> typedef   signed long long __s64;
>> typedef unsigned long long __u64;
>
> include/asm-parisc/types.h:typedef unsigned long long __u64;
>
> For both 32 and 64-bit.
>
> include/asm-sh64/types.h:typedef unsigned long long __u64;
> include/asm-x86_64/types.h:typedef unsigned long long  __u64;
>
> So that's three architectures that violate your first assertion.

Oh, ok, that makes it even easier to say this with certainty:   
Changing the other 64-bit archs to use "long long" for their 64-bit  
numbers will not cause additional warnings.  I'm also almost certain  
there are no architectures which use "long long" for 128-bit  
integers. (Moreover, I can't find hardly anything which does 128-bit  
integers at all).

Cheers,
Kyle Moffett

