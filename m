Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXJSM0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXJSM0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXJSM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:26:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:38714 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbXJSM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JKAvrwzbtk1MR0fBNjOe8/7Y59gytcPbBcnRCVoeUbaXP7wkc/hA2/knq+Fh9QMO2Q0X1RuZwznRxuu/P21IEaxjqhxOYQjbBZXR8DUgicsRsqPKW/pfknTwsJK8SHD7nBJmiYWjjdMIvKiMUcWVSKNFy1SmUH4pWTdUwNQ67Ms=
Message-ID: <5a4c581d0710190526r735d175du346d43a0bd18c9fd@mail.gmail.com>
Date: Fri, 19 Oct 2007 14:26:22 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: g3vbv@blueyonder.co.uk
Subject: Re: 2.6.23-git10 make bzImage problem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4715481F.7060502@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4715481F.7060502@blueyonder.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
> When booted, it complains that kernel size is too big, but size OK for a
> bzImage, not for zImage as is returned by the file command, -git9 was
> OK, x86_64 SMP kernel on two 64x2 boxes.
> I shall supplymy .config if needed, but they are the same as for -git9.
>
>   # l arch/x86/boot/bzImage
> -rw-r--r-- 1 root root 1761496 2007-10-16 22:45 arch/x86/boot/bzImage
>
> # file arch/x86_64/boot/bzImage
> arch/x86_64/boot/bzImage: symbolic link to
> `/usr/src/linux-2.6.23-git10/arch/x86/boot/bzImage'
>
> # file arch/x86/boot/bzImage
> arch/x86/boot/bzImage: Linux/x86 Kernel, Setup Version 0x206, zImage,
> RO-rootFS, root_dev 0x801, swap_dev 0x1, Prompt for Videomode

Same here - but it -git13 seems to be back to proper behavior...

[asuardi@sandman boot]$ file vmlinuz-2.6.23-git? vmlinuz-2.6.23-git??
vmlinuz-2.6.23-git3:  Linux kernel x86 boot executable RO-rootFS,
root_dev 0x807, swap_dev 0x1, Normal VGA
vmlinuz-2.6.23-git6:  Linux kernel x86 boot executable RO-rootFS,
root_dev 0x807, swap_dev 0x1, Normal VGA
vmlinuz-2.6.23-git10: Linux kernel x86 boot executable zImage, version
2.6.23-git10 (asuardi@sandman) , RO-rootFS, root_dev 0x807, swap_dev
0x1, Prompt for Videomode
vmlinuz-2.6.23-git13: Linux kernel x86 boot executable RO-rootFS,
root_dev 0x807, swap_dev 0x1, Normal VGA

--alessandro

 "you feel the sweet breath of time
  it's whispering, its truth not mine"

   (Interpol, 'No I In Threesome')
