Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXGOL3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXGOL3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 07:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXGOL30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 07:29:26 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:58077 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbXGOL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 07:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qlp2u2gIThQT8KDNW3ZmPdTB36xHj8BnWV9wzn/bIU5WvkNJpN64OjcOIC1O6fmnSvH1wF/ZarejpCA2e+uc+xyfhFm16YPFePoqMkyP7QSzYO0XGJ5qESCb7uIer8iHPnbzqZUeD9lvYwIIQ1RlHDvqOQLP8k973zGQweoedZk=
Message-ID: <a781481a0707150429y22b8b10bv413f5f6ba498d3e4@mail.gmail.com>
Date: Sun, 15 Jul 2007 16:59:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695EC25.6050003@arcor.de>
	 <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
	 <200707122040.36800.david-b@pacbell.net> <4699F9CB.5010407@arcor.de>
	 <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/15/07, Timo Lindemann <tlindemann@arcor.de> wrote:
> [...]
> > >>> after this, kernel apparently goes into busy waiting (fans gradually
> > >>> turn louder) and hangs indefinitely. I have also made sure that writel
> > >>> (in linux/include/asm/io.h) really is entered, but never returns.
> > >
> > > Does the current kernel.org GIT tree do the same thing?  A bunch
> > > of USB patches were recently merged, including ISTR one in that
> > > area ...
> > It does the same thing, git5, that is. Sorry I took so long, but I didnt
> > get to testing this earlier.
> >
> > It is just odd that up to (not including) the 2.6.21-series every kernel
> > boots, and after that, they just freeze.

There could be another thing, of course. The kernel sources (or .config)
needn't be the only variable here -- if you're using the "old" kernel image
for the 2.6.20 kernel that works, it could be the case that perhaps you've
upgraded userspace packages (compiler/toolchain) in the meanwhile
that's causing this breakage ... so to test, try compiling the 2.6.20 on
your system again (with same .config) and see if it works now ...
