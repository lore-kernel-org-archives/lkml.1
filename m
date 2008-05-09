Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYEIKSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYEIKSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbYEIKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:18:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:50312 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbYEIKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fLF15g0dLJIRkUKDhtC7JjW4RuWi3NGEX12JblPXf+byPWyZ9vUbF6OzOt5bkLxfdgaaKrBFdAOfW9ac5HUKYPLCKKHhZcyAbjcw2hdJOoEYo9VGYhrjt8kCGhhc/rjqpaOqfG8ZVaj/+KG4e863UGXv03bMdHYhmSKiSZoKPgk=
Date: Fri, 9 May 2008 18:16:42 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509101642.GL2543@hacking>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509093017.GI2543@hacking> <200805091158.21562.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805091158.21562.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:58:21AM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
>At Friday 09 May 2008 11:30:17 WANG Cong wrote :
>> On Fri, May 09, 2008 at 11:13:57AM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
>> >Hello,
>> >
>> >the build (.config attached) failed, make ends with :
>> >...
>> >  AR      arch/x86/lib/lib.a
>> >  LD      vmlinux.o
>> >arch/x86/mach-voyager/built-in.o:(.bss+0x2c): multiple definition of `phys_cpu_present_map'
>> >arch/x86/kernel/built-in.o:(.bss+0x200): first defined here
>> >ld: Warning: size of symbol `phys_cpu_present_map' changed from 32 in arch/x86/kernel/built-in.o to 4 in arch/x86/mach-voyager/built-in.o
>> >make: *** [vmlinux.o] Error 1
>> 
>> Could you please try my quick patch below?
>> 
>yep, that issue is fixed :-)
>

Thanks for your test!

That was a wrong fix, although it looks like passing compile test.
Please try the new one instead. ;-)


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
