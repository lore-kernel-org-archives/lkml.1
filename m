Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYAXU2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYAXU2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYAXU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:28:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:26410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYAXU23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:28:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O4jtFfm1FfgaoaEgxxYQJdXOc8f2AnH6RC06Y/aMtt+BoHldtJtitN3FNaIneG5TQxmEURLkXW5ufko9XvTxb9k43HVy8QxTwN7nWUfwW/Yxy9BzAZrJMCYS8+Jxkor/hCC2HUgT1iwGheD6e4pSdAzTcJlvtTRJvA69RLIfdoY=
Message-ID: <6101e8c40801241228m6026b91bnfcf29c2da3944dfa@mail.gmail.com>
Date: Thu, 24 Jan 2008 21:28:26 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Add common orderly_poweroff() to 2.6.22?
Cc: "Adrian Bunk" <bunk@kernel.org>, "David Miller" <davem@davemloft.net>,
       "Greg KH" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <4798E26D.6010908@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40801210959v1e0f6e55w26187dc93a09a202@mail.gmail.com>
	 <4798C817.6020702@goop.org>
	 <6101e8c40801241033m7347ec5fof8e41c3fe7974feb@mail.gmail.com>
	 <4798E26D.6010908@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Oliver Pinter (Pintér Olivér) wrote:
> > On 1/24/08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >> Oliver Pinter (Pintér Olivér) wrote:
> >>
> >>> Hi all!
> >>>
> >>> commit in mainline 10a0a8d4e3f6bf2d077f94344441909abe670f5a is go in
> >>> the satble 2.6.22
> >>>
> >>> the grund for this question is http://hup.hu/node/49773 .
> >>>
> >>>
> >> Is there a compelling reason?
> >>
> >
> > no, but in forum some person have the question, why the kernel call
> > userspace program and it is secure or not...
> >
>
> Ah, my non-existent knowledge of Hungarian wasn't up to interpreting
> that page ;)
>
> It should be secure if done properly.  Of course, if you set the
> "poweroff" executable to something untrustworthy then you'll have a
> problem, but there's no inherent security problem there.  And if you
> want to do an orderly shutdown, you need to have some amount of help
> from the userspace side of things, and invoking a command is the normal
> way to do this.

yes, i know this

>
>     J
>

the original topic name is : why linux kernel crap ...

the substance is, when from kernel call users-pace program, then come
up more problems with security...
when the fs crash out or the userspace code is breaked, then the
system not shuting down ..

and when it is only code duplication cleanup, then is unneaded for
2.6.22, thanks and, sorry for bad spelling.
-- 
Thanks,
Oliver (pinyo_villany)
