Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbXKJB3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbXKJB3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 20:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbXKJB3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 20:29:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbXKJB3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 20:29:36 -0500
Message-ID: <4735098B.7040305@redhat.com>
Date: Fri, 09 Nov 2007 23:29:47 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, ak@suse.de,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       tglx@linutronix.de, anthony@codemonkey.ws, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH 5/24] smp x86 consolidation
References: <11946337851964-git-send-email-gcosta@redhat.com>	<11946337933104-git-send-email-gcosta@redhat.com>	<11946337991750-git-send-email-gcosta@redhat.com>	<11946338053158-git-send-email-gcosta@redhat.com>	<11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <4734FB67.8080500@goop.org>
In-Reply-To: <4734FB67.8080500@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> This patch consolidates part of the pieces of smp for both architectures.
>> (i386 and x86_64). It makes part the calls go through smp_ops, and shares
>> code for those functions in smpcommon.c
>>
>> There's more room for code sharing here, but it is left as an exercise to
>> the reader ;-)
>>   
> 
> I'm getting link errors in 32-bit:
> 
> arch/x86/kernel/built-in.o: In function `native_smp_send_reschedule':
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/smpcommon.c:262: undefined reference to `genapic'
> arch/x86/kernel/built-in.o: In function `native_smp_call_function_mask':
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/smpcommon.c:113: undefined reference to `genapic'
> 
Ok, it compiled just fine here. I bet it's due to  one of that i386 lots
of variants.
Which subarchitecture are you compiling for, jeremy ?
>     J

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHNQmKjYI8LaFUWXMRAlrLAKCHOb28oE/veBkbVeJZDCbjE8OADwCg81ye
nsBfBe2iLOFHF6dxT4mRauc=
=xjo4
-----END PGP SIGNATURE-----
