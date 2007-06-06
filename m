Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbXFFOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbXFFOFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXFFOFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:05:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:1527 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXFFOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LHVaU+xz8IlaGFxOf26wjVW21G+/CKJ0U5hERe6hYnWdWD4uOJinBMNpcGI/cPDGWa38hguTj+xdlR7Fp2ns2kdCOvYrAsz9HnchfgephfszD7S/Kt3td1ib6i+gztQaLmNRomA5j9kvSSpU7jHKiOEwXvC0+8XC8jvVtINyLw0=
Message-ID: <4cefeab80706060705o210f6a71od074d6cc60e113a9@mail.gmail.com>
Date: Wed, 6 Jun 2007 19:35:40 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Nitin Gupta" <nitingupta910@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 7
In-Reply-To: <20070606125130.GA13419@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80706060534h2461ddffu35f463d7728519a0@mail.gmail.com>
	 <20070606125130.GA13419@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 06, 2007 at 06:04:17PM +0530, Nitin Gupta wrote:
> > Hi,
> >
> > This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
> > version only).
> >
> > * Changes since 'take 6' (Full Changelog after this):
> > 1) Fixed unaligned memory access problems as pointed out by author --
> > LZO_UNALIGNED_OK_{2,4} collapsed to UNALIGNED_OK which is #defined for
> > archs that allow unaligned access (see lib/lzo1x/Makefile). For other
> > archs, we fall down to byte-by-byte access avoiding any unaligned
> > access. In original code, LZO_UNALIGNED_OK_{2,4} resp. describe if we
> > can do unaligned access for ushort and uint32.
>
> Please use get_unaligned() for any unaligned access in kernel space.
>
>

Done.

Thanks,
Nitin
