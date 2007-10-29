Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXJ2IRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXJ2IRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXJ2IRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:17:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:55614 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXJ2IRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PeUlFgWOAcnhbvPMeBro0p3/TSrPYDVUHQRDWs13thwyl2rcoCcQQqHy9ghxhobUr0N5KK6sWO1oZFkUBntZgQSnMLGdAEPrfFDtbrjRw3qFx2QpFxVbAvhM8+NGln9rM13UQ1CLjFzDKwwgYntygO+Em7Yoo7mK9TyJcvQEq5E=
Message-ID: <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
Date: Mon, 29 Oct 2007 01:17:37 -0700
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org,
       "David Howells" <dhowells@redhat.com>, linux-mm@kvack.org
In-Reply-To: <20071029004002.60c7182a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 22 Oct 2007 16:40:57 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> >
> > The problem original occurs with the fb_defio driver (driver/video/fb_defio.c).
> > This driver use the vm_ops.page_mkwrite() handler for tracking the modified pages,
> > which will be in an extra thread handled, to perform the IO and clean and
> > write protect all pages with page_clean().
> >

Hi,

An aside, I just tested that deferred IO works fine on 2.6.22.10/pxa255.

I understood from the thread that PeterZ is looking into page_mkclean
changes which I guess went into 2.6.23. I'm also happy to help in any
way if the way we're doing fb_defio needs to change.

Thanks,
jaya
