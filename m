Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZGWUu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZGWUu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZGWUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:50:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:13048 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZGWUuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PgwQAz+dPtavgItm02mrEioW9rnUSKJezLvO0FJ4FTpSSObveKeMm+OXyV+TSmqXmg
         5FBLovnl+dguvNN8MN5bwP6oDp5ca4+g0B9y3EMK5f+bW7/6QSETEIct/223tEs5m6VY
         hLYCjhMDDeL0TlVUYWymPWUVRfEAEhcLAlSTc=
MIME-Version: 1.0
In-Reply-To: <4A67CD97.8000609@zytor.com>
References: <110c8b2e0907221415q77f7416ehcff4ad26d834bce2@mail.gmail.com>
	 <4A67CD97.8000609@zytor.com>
Date: Thu, 23 Jul 2009 13:50:55 -0700
Message-ID: <110c8b2e0907231350v122543a0n9a3aabc3aee59623@mail.gmail.com>
Subject: Re: Way to combine kernel and initrd on x86 platform?
From: Subodh Nijsure <nijsure.subodh@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 7:40 PM, H. Peter Anvin<hpa@zytor.com> wrote:
> On 07/22/2009 02:15 PM, Subodh Nijsure wrote:

>
> If your bootloader can support ELF, Multiboot, or NBI, you can use
> Wraplinux:
>
>        http://www.kernel.org/pub/linux/utils/boot/wraplinux/
>
> bzImage support would be possible, but it isn't in this version (noone
> has asked for it).
>

Sorry if I am not being very smart  here, confused by the remark "
bzImage support would not be possible"

I was able create wrapped image using command

wraplinux -p "console=ttyS0,115200" -i initrd.gz -o
vmlinux.initrd.wrap arch/i386/boot/bzImage

I am using wraplinux version 1.6

if I use any other image  wraplinux doesn't find the version
information and initrd image doesn't get attached.

What file should I be specifying as the 'kernel' when I execute
wrapimage  if not the bzImage?

( I am working with 2.6.23 kernel)

On my board I can boot the standard bzImage, but not able to load the
wrapped image produced by wraplinux command. Would very much
appreciate hints...

Regards,
/Subodh



>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
