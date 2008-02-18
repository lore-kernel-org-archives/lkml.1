Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYBRGEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYBRGEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYBRGED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:04:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:33122 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYBRGEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tdieUdpZ8NiGe3qc/dOXPV5br1Owg/0jleQpgF56CUzgBXqxnJij+54I5/X2rgg3XfyC2ARWFUCfW3SusfWHNX6n2Q70cbmE1Nx9aj3wXD8MX2UTEWMbuc3EuNzn1KscMuZVQsX7EiiiGfOdCk/9qvUYf0UAdsxNxk3AGfPCY4Y=
Message-ID: <86802c440802172203m744d8408i8611522a387b6bde@mail.gmail.com>
Date: Sun, 17 Feb 2008 22:03:57 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1 (x86 MCE build error)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080217211755.8c2367cc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <20080217211755.8c2367cc.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:17 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
>
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>
> It's possible to config a specific CPU and also enable Intel MCE checks
> and AMD MCE checks, ending with this:
>
> arch/x86/kernel/built-in.o: In function `smp_thermal_interrupt_init':
> mce_amd_64.c:(.text+0xd7ea): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd800): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd863): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd888): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd8b1): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd8d8): undefined reference to `num_k8_northbridges'
> mce_amd_64.c:(.text+0xd8f3): undefined reference to `k8_northbridges'
> mce_amd_64.c:(.text+0xd917): undefined reference to `num_k8_northbridges'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> .config file is attached.

same config no problem with mainline.

YH
