Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbXHMVMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbXHMVMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760710AbXHMVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:12:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:46850 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbXHMVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lw8lZtWKzan10/AnCZnnwCajoQgkZWkmyaz38mcx5NijB2F6in54il09LmyKvyoHsEa5WFkCGNw1HnL06zWTRPdLSfLBDUJrWAQz1BCq70synJVH7c5Sx9hpA0MAe60zmmb/46OjfK6IxunI6/OkijwjIXS8gX0w4gv2HkoD3fo=
Message-ID: <9a8748490708131412k659cdd34hba76df931428d673@mail.gmail.com>
Date: Mon, 13 Aug 2007 23:12:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Unexpected busfree in Message-in phase
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0708130844k888bcc9ye06c766d0e1bdcab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
	 <6bffcb0e0708130844k888bcc9ye06c766d0e1bdcab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Jesper,
>
> On 11/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > Hi,
> >
> > I just noticed this in dmesg :
> >
> > [ 3216.262987] (scsi0:A:4:0): Unexpected busfree in Message-in phase
> > [ 3216.263058] SEQADDR == 0x16c
> > [ 3216.263724]  target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 16)
> >
> > That's all there is in addition to the normal bootup messages, just
> > those 3 lines.
> > The machine is doing fine at the moment, no ill effects so far, but an
> > explanation of what exactely could be causing that and whether or not
> > it is a (fixable) problem would be very nice :-)
> >
> >
> > Some details :
> >
> > $ scripts/ver_linux
> > If some fields are empty or look unusual you may have an old version.
> > Compare to the current minimal requirements in Documentation/Changes.
> >
> > Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST
>
> Is this a regression? I do not have this commit
>
Hmm, neither do I, it must be from a build from one of my local
branches (unfortunately it seems like it's one I don't have around any
more).
Ok, so I guess I'll have to try and see if it happens again with a new
build - although I doubt that it's something that was caused by one of
my own patches since I've not been doing anything to the aic7xxx
driver lately beyond pretty trivial stuff, but I guess I can't rule it
out.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
