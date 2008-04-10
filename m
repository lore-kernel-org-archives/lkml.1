Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYDJVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYDJVPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYDJVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:15:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:36757 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYDJVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WLASSerdNnHsAFWE+D8IQVere/IBCrWcy6ZPUaBxF6qxhNap4AupG+ilfslgSrPYz6nEaTiJZRYm584gd3M7fSyEBYZP37YCmMVRUYb/uuX5rHEhB4AhDkCxaVpB+bPzjyiAWPHLdBtERBYuBc2XerkeEJ+9OO39N+qCK18azB4=
Message-ID: <86802c440804101415o55af93c8o8f4dc54dfad8662e@mail.gmail.com>
Date: Thu, 10 Apr 2008 14:15:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor -- payload_length
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
In-Reply-To: <47FE7A6C.1070405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
	 <47FE7A6C.1070405@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 1:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > >  FWIIW, i've been booting allyesconfig bzImages for a long time (with
> > >  only minimal amount of drivers disabled - mostly old ISA ones that
> > >  assume the presence of the real hardware), and they boot and work fine
> > >  on both 32-bit and 64-bit typical whitebox PCs. That means huge
> bzImages
> > >  that decompresses into a ~41 MB kernel image. I'd expect that to be a
> > >  rather severe test of the decompressor.
> > >
> >
> > payload_offset and payload_length in arch/x86/boot/head.S
> > seems to be used by bootloader  to seat the bzImage.  or just use size
> > of bzImage
> >
> >
>
>  payload_offset/payload_length are used by loaders for nonstandard platform
> loaders which don't actually load a bzImage.
>
>
>
> > long term, should add one field after payload_length like
> > payload_unzip_length to make bootloader or kexec what buffer size
> > needed.
> >
>
>  You can look at the payload headers for that.
>

arch/x86/boot/compressed/head_64.S?

YH
