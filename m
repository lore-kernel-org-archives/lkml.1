Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXCSQef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXCSQef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXCSQee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:34:34 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:62415 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030354AbXCSQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BfFdkGJtu9cT3gDZ0z11vfqQ2CW4rd8PGkSrc2rzF6nSyEl4uMCZTVEcPeoEmqQ7INfqKi5SgUsWg2p9LyCxIifO6+8uIXOUZyh3H37nkoKuwd0G/I3EuReK/F5vw+osIg8saK7k6x3kabMZ+0iaeOthI9x+/onKUONRnYY/C+E=
Message-ID: <6bffcb0e0703190934i1c0d3e9av1300883271dcea53@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:34:31 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Alan Cox" <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	 <45FD8684.4030501@googlemail.com>
	 <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
	 <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
	 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 19/03/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> > Hi Micael,
> >
> > On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> > > Pekka, can you take a look at this problem and fix my initrd? :)
> > >
> > > GOOD
> > > #
> > > revoke-special-mmap-handling.patch
> > > revoke-core-code.patch
> > > revoke-core-code-misc-fixes.patch
> > > revoke-core-code-fix-shared-mapping-revoke.patch
> > > revoke-core-code-move-magic.patch
> > > revoke-support-for-ext2-and-ext3.patch
> > > revoke-add-documentation.patch
> > > revoke-wire-up-i386-system-calls.patch
> > > BAD
> >
> > Oh, sorry about that. Can you confirm that the patch
> > revoke-special-mmap-handling.patch is bad?
>
> Yes, revoke-special-mmap-handling.patch is bad.

+               if (unlikely(vma->vm_flags & VM_REVOKED))
+                       return -ENODEV;

Why -ENODEV?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
