Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXKESf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXKESf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXKESfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:35:16 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:29795 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXKESfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGte7hx9MpPT5vO+nzuOp4lslxBfhWVrK4FxUd3d/aahcThIn/7aFgnRUOpBebwKRXolx1mvy5OdaMC4ouK5pBMh7YIEMSfZ+WH84E/QP81D6ety+mT/3YD75ggyY11jnYYWqnsFajNSphBDtTli4SvFhajd6RxIqrXtREh/iYM=
Message-ID: <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
Date: Mon, 5 Nov 2007 11:35:13 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Cc: "Neil Brown" <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org,
       "=?ISO-8859-1?Q?BERTRAND_Jo=EBl?=" <joel.bertrand@systella.fr>
In-Reply-To: <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	 <18222.16003.92062.970530@notabene.brown>
	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Mon, 5 Nov 2007, Neil Brown wrote:
>
> > On Sunday November 4, jpiszcz@lucidpixels.com wrote:
> >> # ps auxww | grep D
> >> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> >> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> >> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
> >>
> >> After several days/weeks, this is the second time this has happened, while
> >> doing regular file I/O (decompressing a file), everything on the device
> >> went into D-state.
> >
> > At a guess (I haven't looked closely) I'd say it is the bug that was
> > meant to be fixed by
> >
> > commit 4ae3f847e49e3787eca91bced31f8fd328d50496
> >
> > except that patch applied badly and needed to be fixed with
> > the following patch (not in git yet).
> > These have been sent to stable@ and should be in the queue for 2.6.23.2
> >
>
> Ah, thanks Neil, will be updating as soon as it is released, thanks.
>

Are you seeing the same "md thread takes 100% of the CPU" that Joël is
reporting?
