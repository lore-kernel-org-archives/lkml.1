Return-Path: <linux-kernel-owner+w=401wt.eu-S1422918AbXBHGmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422918AbXBHGmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 01:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422783AbXBHGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 01:42:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:57457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422918AbXBHGmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 01:42:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F+JmPLNaeBr8ElaS6NdjoStBDdVGdPpcaOTkYdUBXM8MhroCsr3L5ebKMZR3hzVmqAGCCR5Ho53Rire0jGFzEXAhyBK/aOUsOFwm74uhDcFlGvK+bCgZJyVyXgq2YyyL2mIgWAtc3K10bpkEiJJkZ1e/lC6Pan1PXI8eZp4gw8s=
Message-ID: <8bd0f97a0702072242g4f4b8b9djcd1651e1637eaaa8@mail.gmail.com>
Date: Thu, 8 Feb 2007 01:42:51 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: + search-a-little-harder-for-mkimage.patch
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Roman Zippel" <zippel@linux-m68k.org>, sam@ravnborg.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kai Germaschewski" <kai@germaschewski.name>
In-Reply-To: <20070208064347.GP22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	 <20070207220435.GC22699@flower.upol.cz>
	 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
	 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
	 <20070207203047.51a95ad0.akpm@linux-foundation.org>
	 <20070208052439.GL22699@flower.upol.cz>
	 <20070207211921.1f0220a4.akpm@linux-foundation.org>
	 <20070208055832.GN22699@flower.upol.cz>
	 <8bd0f97a0702072158r36046dd7w64a8c7b5da1a5f9a@mail.gmail.com>
	 <20070208064347.GP22699@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Thu, Feb 08, 2007 at 12:58:26AM -0500, Mike Frysinger wrote:
> > On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> > >Trivial shell scripts, especially for embedded archs (Blackfin is
> > >one, IIRC), may be easily converted.
> >
> > yes, but Blackfin is no-mmu so converting the script to use POSIX
> > shell is pointless to us since no-mmu is not a self-hosting
> > environment
>
> Heh, did i say POSIX?

/bin/sh is the POSIX shell ... if you want to switch off of /bin/bash,
then the only other sane option is /bin/sh which means rewriting the
code to be POSIX compliant

> I said bloated shell, from man bash:
>
> BUGS
>        It's too big and too slow.

we get it, you dont like bash, why do you feel the need to keep making
these statements ?
-mike
