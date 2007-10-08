Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXJHXJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXJHXJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXJHXJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:09:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:47764 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXJHXJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GeTlvTDVGmV48F0T8j9W37zbNeQlW1y3BZBY4nU7YqBKKkkBSoycTsxGJJf9uFKRKxVqCVwJ+uyLRduk8lWiCIkGg95BHqQy8uH7f246CwTbUJErYXsHQEJ6wJhAfOe8sg6jPJqL2bQfKoHr5tX1w1dHxrDdIrAB+ZOz3NosxA0=
Message-ID: <2c0942db0710081609y139646c1lee0915688295e595@mail.gmail.com>
Date: Mon, 8 Oct 2007 16:09:11 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree
Cc: akpm@osdl.org, yanzheng@21cn.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071008184044.GA1875@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710081705.l98H5eoj009691@imap1.linux-foundation.org>
	 <20071008184044.GA1875@martell.zuzino.mipt.ru>
X-Google-Sender-Auth: 1186d6982df9a478
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Oct 08, 2007 at 10:05:40AM -0700, akpm@linux-foundation.org wrote:
> > --- a/mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages
> > +++ a/mm/fremap.c
> > @@ -160,7 +160,7 @@ asmlinkage long sys_remap_file_pages(uns
> >       if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> >               goto out;
> >
> > -     if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > +     if (!(vma->vm_flags & VM_CAN_NONLINEAR))
>
> Ick.

Perhaps a good candidate for checkpatch.pl? (Andy cc:d.)

Ray
