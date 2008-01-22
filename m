Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYAVByf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYAVByf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYAVBy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:54:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:39910 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYAVBy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YdDIKVf+SI1jPhQK94MLKITfKR5oHo8c8s6HsmCm/mtIe3nxE4QWW/hdAu22cCLAqQSaew9nUcHG49eN4VDN725S/yRHfj9j6D1oD1exXmytWs8JJHFxTkFhbPE5Tm6HzY12HE1HRcdlOXDKKM0rDL5ZAo3JSgA//XWsAW79SfI=
Message-ID: <9a8748490801211754t51cbc65bg20dea2f8cf6d4516@mail.gmail.com>
Date: Tue, 22 Jan 2008 02:54:26 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <4df4ef0c0801211751w39d7b9e5ne2e8b788051d3e3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	 <12009619584168-git-send-email-salikhmetov@gmail.com>
	 <9a8748490801211740r5c764f6ev9c331479f63ef362@mail.gmail.com>
	 <4df4ef0c0801211751w39d7b9e5ne2e8b788051d3e3a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> 2008/1/22, Jesper Juhl <jesper.juhl@gmail.com>:
> > Some very pedantic nitpicking below;
> >
> > On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
...
> > > +               if (file && (vma->vm_flags & VM_SHARED)) {
> > > +                       if (flags & MS_ASYNC)
> > > +                               vma_wrprotect(vma);
> > > +                       if (flags & MS_SYNC) {
> >
> > "else if" ??
>
> The MS_ASYNC and MS_SYNC flags are mutually exclusive, that is why I
> did not use the "else-if" here. Moreover, this function itself checks
> that they never come together.
>

I would say that them being mutually exclusive would be a reason *for*
using "else-if" here.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
