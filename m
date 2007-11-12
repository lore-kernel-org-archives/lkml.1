Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbXKLWuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbXKLWuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXKLWub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:50:31 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:44329 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbXKLWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CinknqrJaYWCYvdfBnAKFrzw6j8rIusvlgAABdgWH8zTJDqDhC58Wr+DZhTa2iGOzjyMIr3Wm+IWeZewxypAWcesrKAkRD0HD6dkcGirefGr90JpyubL3x9L+z+JgK/hBoyKnB2ObSEUCE95491gR7Z1zyx5QS4on3/WoAn5ons=
Message-ID: <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com>
Date: Mon, 12 Nov 2007 14:50:20 -0800
From: "SL Baur" <steve@xemacs.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
Cc: "David Howells" <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
In-Reply-To: <20071112115353.227f35cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110181416.31dc2614.akpm@linux-foundation.org>
	 <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	 <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
	 <6214.1194881680@redhat.com>
	 <20071112115353.227f35cb.akpm@linux-foundation.org>
X-Google-Sender-Auth: a05c83f422d8d31b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 12 Nov 2007 15:34:40 +0000 David Howells <dhowells@redhat.com> wrote:
>
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > > +# -*- makefile -*-
> > >
> > > what's that?
> >
> > Ah...  That tells emacs that it's a makefile.  In Kbuild.asm emacs thinks its
> > an Assembly file and not a makefile.  This causes it to attempt to do
> > automatic indentation on it.  Do you want me to drop these annotation
> > comments?
>
> Doesn't worry me, but I'd suggest that such annotation be added to all such
> files in a single separate patch.
>
> otoh it'd be pretty dumb of emacs if there wasn't some way of telling it
> the type of a file external from that file itself.

(push '("/Kbuild" . makefile-mode) auto-mode-alist)

-sb
