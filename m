Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYDFRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYDFRej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYDFRec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:34:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:22870 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYDFReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PpBJwxdZeKvhRIehsgsigtvaqOY8+UEe1VL7ZDYWguPK4PVstYiZIvWQu/B2EDr+AI0ZHuIsVsCTVzxUKpU5JQpa66TR1OMxEaAVqpyqFWA30G7NeyoGF3ts6VnpAbTuK0knV9hv0+EXSpIJW4PrUwmppAmLghl5TxaFJk/uU7w=
Message-ID: <86802c440804061034y1f54dc2bhd861f8c6e9e6edbe@mail.gmail.com>
Date: Sun, 6 Apr 2008 10:34:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
Cc: "Ian Campbell" <ijc@hellion.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <47F90788.90304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
	 <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
	 <47F8FC9C.9090603@zytor.com>
	 <86802c440804061019t1cc0e66ejee69b5d90f052b0d@mail.gmail.com>
	 <47F90788.90304@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 6, 2008 at 10:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yinghai Lu wrote:
>
> > On Sun, Apr 6, 2008 at 9:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > > Yinghai Lu wrote:
> > >
> > >
> > > > so will cost every bzImage extra memory copy? that could be 18M or
> > > > even more big.
> > > >
> > > >
> > >  I wouldn't worry about that.  You will typically have several copies of
> the
> > > images during the execution of the boot loader.
> > >
> >
> > i put all drivers needed in kernel.
> > 1. bootloader copy bzImage (6M) to memory
> > 2. arch/x86/boot/compressed/head_32.S, will copy bzImage to end of
> > buffer to do uncompress on possiton.
> > 3. parse_elf will copy the vmlinux (the uncompressed, that is some big,
> 18M)
> >
> > I suggest that could have special elf header, and will only have one
> > PT_LOAD, and avoid the copy, and just offset start address of
> > uncompressed kernel for jump later.
> >
>
>  Once again, I think you will have a hard time measuring the time
> difference.

ok.

forget about my proposal..

YH
