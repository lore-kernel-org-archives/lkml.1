Return-Path: <linux-kernel-owner+w=401wt.eu-S935768AbXGSALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768AbXGSALP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763712AbXGSAK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:10:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:11678 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974AbXGSAK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N5qMpymyocR74N+PsCYWkdZuiuHs5KF1R7HoIaXNUM8bkNidPs/oDMduwmSJM2JA44X34YJU9v+ikcvGHOEqVydQN5dw8V2zfGFC34DbdgWkjJJorRN/HSUp1iBjlWFjzk3Z8wvlprHno1ttzcaNNs3Uz2seyKmljakspAF7vJo=
Message-ID: <9a8748490707181710h39a4f102j36855f853f46b743@mail.gmail.com>
Date: Thu, 19 Jul 2007 02:10:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Tony Borras" <tonyb@sysdev.org>
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070718160309.530d2ca7.tonyb@sysdev.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8HOJx-2nt-21@gated-at.bofh.it> <8HOJx-2nt-23@gated-at.bofh.it>
	 <8HOJx-2nt-25@gated-at.bofh.it> <8HPFA-3Pn-17@gated-at.bofh.it>
	 <8I29I-6CE-21@gated-at.bofh.it>
	 <20070718160309.530d2ca7.tonyb@sysdev.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Tony Borras <tonyb@sysdev.org> wrote:
> On Tue, 17 Jul 2007 22:50:10 +0200
> Willy Tarreau <w@1wt.eu> wrote:
>
> > Hi Tony,
> >
> > [ first, please always keep people in CC on LKML since it's
> > very easy to
> >   miss a thread ]
> >
> > On Mon, Jul 16, 2007 at 11:23:57PM -0800, Tony Borras wrote:
> > > On Tue, 17 Jul 2007 07:20:06 +0200
> > > Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > > could you please report what the problem was, in case it's
> > > > not fixed yet ?
> > >
> > > Ok, reproduced error at ./net/ipv4/fib_semantics.c
> > >   line 436 changed label:
> > >                    errout -> err_inval
> >
> > I don't know where you downloaded 2.4.35-pre5 from, but I've
> > checked the sources and could not find any reference to
> > "errout" here in any version!
> >
> > Or what is possible is that your 2.4.34 kernel got corrupted
> > on your disk after applying any patch. Sometimes, some shell
> > scripts providede with some
>
> Negatory on that, Willy!
>
> Here is what I have verified:
>   At kernel.org:/pub/linux/v2.4
>
> file: patch-2.4.34.3.bz2 has the corruption at line 213:
>   goto errout
>
> That is where that came from, when I patched my 2.4.34 to arrive
> at 2.4.34.5, before applying the 2.4.35.rc5 patch!
>
That sounds wrong. To the best of my knowledge, the 2.4.35-rc5 patch
should be applied on top of 2.4.34, not on top of 2.4.34.5 ...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
