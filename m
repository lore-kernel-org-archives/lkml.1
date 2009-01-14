Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZANDK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZANDK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZANDKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:10:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:60711 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZANDKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pot5YPVGJIPCO6t/yK7wF5fSGCRcL+mOlNtuNJ0cjc6nIwZwDbXPzO2E4DbiXsiGd2
         iO0+DXJRQtZfsBGJoDROKXCpvbwMDWL/vrh4F0nbqHYxHPnWKQERj/u/+0MLC8cHO5X+
         uKiEGF4i3ke1i+tBhgwzQie+zSIJInaQJmMeY=
Message-ID: <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
Date: Tue, 13 Jan 2009 22:10:18 -0500
From: "James Kirin" <james.kirin40@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <adaeiz6k4o4.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	 <adaeiz6k4o4.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply, Roland. Unfortunately, this continues
happening after having installed the most recent version of the BIOS
available from Dell.

I understand this is a problem in the BIOS and not the kernel, but is
there a way to have the kernel work around this bug in the BIOS and
make that memory accessible? Eg,

http://www.gossamer-threads.com/lists/linux/kernel/991748#991748

The difference seems to be that the BIOS on this machine I am using
does list 8GB memory available.

Thanks for any help,

James

On Tue, Jan 13, 2009 at 9:22 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > I am running kernel 2.6.28 on a computer with 8GB RAM. The BIOS
>  > detects all 8GB, yet
>  >
>  > jk@as12:~$ free
>  >              total       used       free     shared    buffers     cached
>  > Mem:       3622504     799696    2822808          0      90936     369604
>  > -/+ buffers/cache:     339156    3283348
>  > Swap:      6867776          0    6867776
>
> The message in your kernel log:
>
> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4096MB of RAM.
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1662 mtrr_trim_uncached_memory+0x283/0x2a4()
>
> is a clue.  You might want to look for a BIOS update for your
> motherboard.
>
>  - R.
>
