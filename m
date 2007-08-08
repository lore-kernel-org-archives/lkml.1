Return-Path: <linux-kernel-owner+w=401wt.eu-S935811AbXHHXDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbXHHXDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762368AbXHHXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:03:41 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:16437 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbXHHXDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=taWLh6YSaX5/XEXWt9uFeEJhpfY+iG2q87C36QZoGzMjpw2GrommReE93cGpheHmfzpxSVvjVLPuw70zGgpgIyAENYUJhORSuiGoHPbZFacMkI1GJHNka5kfSFVL+B/WMZbTtKoSakzJDXLuPsYB6J5nig11NxxWqBFD8dR0ZXA=
Message-ID: <9a8748490708081603k65746311sad595947fd5ab971@mail.gmail.com>
Date: Thu, 9 Aug 2007 01:03:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH 2/3] UIO: Documentation
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Hans J. Koch" <hjk@linutronix.de>
In-Reply-To: <14166.1186611154@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718232332.GA4620@kroah.com>
	 <11848012053678-git-send-email-gregkh@suse.de>
	 <11848012122374-git-send-email-gregkh@suse.de>
	 <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
	 <14166.1186611154@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2007, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 08 Aug 2007 23:36:00 +0200, Jesper Juhl said:
>
> > Do we really want this?
> >
> > In my oppinion we run the risk here of encouraging behaviour akin to
> > what NVidia is doing - release a small kernel "glue" module and then
> > keep the driver proper in a binary blob (in userspace, but still a
> > binary blob).
> > If the company goes out of business and take their driver source with
> > them then users are left with a useless, un-debugable, un-maintainable
> > binary blob.
> > Don't we instead want to encourage/pressure people to release specs
> > and/or source code for their hardware/drivers so open, modifiable
> > drivers can be written?
> >
> > This opens the door for people to start writing closed drivers. In the
> > long run that seems to me like a bad deal for our users.
>
> On the other hand, given that we've always said that closed-source stuff in
> userspace is OK, the only way to not let *that* horse out of the barn is to
> not merge UIO at all.
>
Exactely.

> If you have UIO in the kernel talking to stuff in userspace, you're going to
> have to deal with closed-source stuff at the userspace end of the pipe.
>
Naturally.
I just wanted to get people to think about whether or not this is
something that we are willing to accept for device drivers - I guess
it is since UIO is already merged - I just think it's a potential step
back in terms of encouraging open source drivers for Linux, that's
all.

> Unless somebody can come up with some great feat of sophistry to avoid that?
>
I think the only way to avoid it is to not provide something like UIO.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
