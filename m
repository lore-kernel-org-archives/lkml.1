Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbZBKFGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbZBKFGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 00:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZBKFGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 00:06:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:43138 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZBKFGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 00:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xv1f+rpiJmloJtpDRnKlcZo/qOZiBLYBfD7BHS1bnhsQAYOngQkQR9pw18ThgVS+pk
         7eSMiqtp3LN2zPoIPWLFVfxeyQIQAtvFXLoHeej9SsYQoZQEyWNWr5WmJ9zJ0LZJ194U
         FLQk58ys1vNY6ZH2nLQAtRdkW5N8iyft30laI=
MIME-Version: 1.0
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com>
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com>
	 <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com>
	 <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org>
	 <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com>
	 <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com>
	 <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com>
	 <4991E752.8010903@kernel.org>
	 <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com>
Date: Tue, 10 Feb 2009 21:06:39 -0800
X-Google-Sender-Auth: 59f1c6fc473e54d0
Message-ID: <86802c440902102106o54e4ea2fua4d108c8564ff8a@mail.gmail.com>
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 
	on IBM x3400
From: Yinghai Lu <yinghai@kernel.org>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:19 PM, Morten P.D. Stevens
<mstevens@win-professional.com> wrote:
> Hi,
>
>> can you post /proc/mtrr in 2.6.29-rc3 and old kernel without
> warn_on..?
>
> okay... affected are 2.6.26, 2.6.27, 2.6.28 and 2.6.29-rc3. (previous
> kernels are not tested)
> a small update: debian 2.6.26 lenny default kernel should be also
> affected.
>
> here /proc/mtrr from 2.6.28.4:
>
> ibm-x3400:~# cat /proc/mtrr
> reg00: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
> reg01: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
> reg02: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
> reg03: base=0x0bff80000 ( 3071MB), size=  512KB, count=1: uncachable
>
> /proc/mtrr linux 2.6.24 (from gentoo 2008.0 amd64 livecd) no errors in
> dmesg
>
> reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

so there is some problem with your BIOS, please ask the vendor to
provide one to make
2.6.24 happy.

YH
