Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXFWJzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXFWJzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXFWJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:55:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:50118 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXFWJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:user-agent:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=lUOl/S63kYhRqtflwPV3zvLZIVZYMYgSiCkBA8Q6lG1Da54IBy5eu5HMkPA5gw7GSp44Ka+7x2XDm5POXdNlVHNuMCTT84C/BlvpDH1H1dOmrjOgsYJnIIkgTemwOfNOrSLfe3JaSRsq518suwgC9uuyjLCcGOniYuxEi//QKLQ=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v18
User-Agent: KMail/1.9.6
References: <20070622220202.GA16872@elte.hu> <200706221908.05460.gene.heskett@gmail.com> <20070623071153.GB6845@elte.hu>
In-Reply-To: <20070623071153.GB6845@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 23 Jun 2007 05:55:24 -0400
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706230555.24415.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> patching file kernel/softirq.c
>> patching file kernel/sysctl.c
>> The next patch would delete the file l/kernel/sched.c,
>> which does not exist!  Assume -R? [n]
>>
>> How to proceed?
>
>oops - just ignore it, or re-download the patch (i fixed it).
>
>	Ingo

answering n for all that, I note the build, at the end of the make bzImage,
spits out this:
  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0x845d): Section mismatch: 
reference to .init.text:amd_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x8462): Section mismatch: 
reference to .init.text:cyrix_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x8467): Section mismatch: 
reference to .init.text:centaur_init_mtrr (between 'mtrr_bp_init' 
and 'mtrr_save_state')
WARNING: arch/i386/kernel/built-in.o(.text+0x9284): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x9298): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')
WARNING: arch/i386/kernel/built-in.o(.text+0x92bc): Section mismatch: 
reference to .init.text: (between 'get_mtrr_state' and 'generic_get_mtrr')

But then proceeds with the make modules stage.  I believe I've seen references
to this in other threads.  Is It Serious?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Debug is human, de-fix divine.
