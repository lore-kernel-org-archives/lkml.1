Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYHVWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYHVWLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYHVWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:11:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:24589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYHVWLM (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OcmlZnY1AFLIoGlulXCo27pAi/xMfSj+2v7ATtPYmzwCxwX6W53QFWiazGGl7LQ4v/
         gYsE1mE9wsudNCJA525C2xL+U99dZKvjr0nH+kdwTKLlQP/EA3vFnbIbgfC2vAIn/aAg
         dePMo1e+cwbIylwl+A41/lXX+TTDYLzhHeRtg=
Message-ID: <48AF3905.70304@gmail.com>
Date: Fri, 22 Aug 2008 15:09:09 -0700
From: Will Marone <wjmarone@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@AM.SONY.COM
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
> code ;-).
> When mounting the image, I got the crash below:
>
> | attempt to access beyond end of device
> | loop0: rw=0, want=4920, limit=4912
> | Unable to handle kernel paging request for data at address 0x00000028
> | Faulting instruction address: 0xd000000000037988
> | Oops: Kernel access of bad area, sig: 11 [#1]
> | SMP NR_CPUS=2 PS3
>
> When mounting (also on PS3) an image created on ia32, I get a different crash:
>
> | axfs: wrong magic
>   ^^^^^^^^^^^^^^^^^
> | Unable to handle kernel paging request for data at address 0x000003a8
> | Faulting instruction address: 0xd0000000000355f0
> | Oops: Kernel access of bad area, sig: 11 [#1]
> | SMP NR_CPUS=2 PS
Geert,

Thanks for giving it a spin, especially on a platform as different from 
ours as the PS3.

Before I dig more into what happened, I was wondering if you could tell 
me a bit more
about your environment, particularly how you supplied the filesystem to 
the kernel and
your mount commandline (also, if you used a boot commandline, what it was.)

My first guess would be a ppc64 compiled UML session, but I'd like to be 
a bit more sure.


Will Marone
