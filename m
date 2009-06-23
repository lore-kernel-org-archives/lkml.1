Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZFWHHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZFWHHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZFWHHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:07:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZFWHHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:07:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: module version magic and arches with symbol prefixes
Date: Tue, 23 Jun 2009 16:37:36 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> <8bd0f97a0906190614x2ed27fcdrb59ea339eb45ba82@mail.gmail.com> <200906191307.45135.rgetz@blackfin.uclinux.org>
In-Reply-To: <200906191307.45135.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231637.38819.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009 02:37:45 am Robin Getz wrote:
> On Fri 19 Jun 2009 09:14, Mike Frysinger pondered:
> > On Fri, Jun 19, 2009 at 08:54, Robin Getz wrote:
> > > On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
> > >> No, it means the kernel didn't build properly.
> > >
> > > Or a module didn't build properly.
> >
> > nah, when i talked to you earlier i was wrong -- this find_symbol() is
> > looking up the symbol in the kernel, not in the module.  the lookup of
> > the symbol in the requested module actually works.
>
> OK - Yeah, I see it now in the kernel proper. (sorry for the noise)
>
> Wouldn't it make sense to move this somewhere else then? and add a
> __initcall() for it? We should only need to check for it once - it would
> make things insignificantly faster, and smaller :)

Patch welcome.

Rusty.


