Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYBJUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYBJUZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYBJUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:25:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:4620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYBJUZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:25:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fjlPzjGOC1XPV9pB4/8zn0CAVHE2b6FWBTCgBnlcdjSk8rFm+tKkPtIR1ns9zXi9O4eTfj4GPYyMKl2ocFbU+oVqEup0xe0qLi5nID+5DD9jd2gAw7S05wckEG9DuomE91WxpmUi3/3MPQPWIR7DRMdsw2mYW1xT4ufaCn0Q1IE=
Message-ID: <86802c440802101225k2a7a1dc9pe6d3f26af1c5b452@mail.gmail.com>
Date: Sun, 10 Feb 2008 12:25:02 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080210201955.GE5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128225334.GD4720@kroah.com>
	 <20080129030340.GE20198@parisc-linux.org>
	 <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
	 <47AB299D.4000500@redhat.com>
	 <20080209124138.GA28967@parisc-linux.org>
	 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	 <20080210072116.GA12375@kroah.com>
	 <20080210145122.GC5299@parisc-linux.org>
	 <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
	 <20080210201955.GE5299@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 12:19 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> On Sun, Feb 10, 2008 at 12:16:43PM -0800, Yinghai Lu wrote:
> > On Feb 10, 2008 6:51 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> > > On Sat, Feb 09, 2008 at 11:21:16PM -0800, Greg KH wrote:
> > > > Can I get a revised version of this, without the incorrect hunk?
> > >
> > > Sure.  I've even rebased it against current HEAD.  Damn whitespace
> > > cleanup introducing unnecessary conflicts ....
> > >
> > > I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> > > This patch is just cleanup (and takes care of some future concerns).
> >
> > your patch and Ivan's patch should be merged in one...
>
> Why?

Even Greg didn't know that there was another patch need to be applied
before this one yesterday.

he said there was some hunks..

YH
