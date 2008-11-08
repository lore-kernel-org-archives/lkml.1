Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKHKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKHKh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYKHKhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:37:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYKHKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:37:49 -0500
Date: Sat, 8 Nov 2008 05:37:45 -0500 (EST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
cc: Andre Kelmanson <akelmanson@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       Bouwsma Barry <freebeer.bouwsma@gmail.com>,
       Dan Kreiser <kreiser@informatik.hu-berlin.de>,
       Frank Neuber <fn@kernelport.de>,
       Jelle de Jong <jelledejong@powercraft.nl>,
       John Stowers <john.stowers.lists@gmail.com>,
       Lukas Kuna <lukas.kuna@evkanet.net>,
       Stefan Vonolfen <stefan.vonolfen@gmail.com>,
       Stephan Berberig <s.berberig@arcor.de>,
       Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
       Vitaly Wool <vwool@ru.mvista.com>, Zhenyu Wang <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       greg@kroah.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/7] Adding empia base driver
In-Reply-To: <d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811080529000.7489@bombadil.infradead.org>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>  <200811011459.17706.hverkuil@xs4all.nl>  <20081102022728.68e5e564@pedra.chehab.org>  <a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>  <20081108081508.496f6582@pedra.chehab.org>
 <d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008, Markus Rechberger wrote:

> As written earlier already I don't think that I didn't follow any
> rules here since I provided single
> patches at the very first beginning
>
> http://mcentral.de/v4l-dvb/
> (this is all kernel code and only kernel code).
>
> That work didn't get attention and due a different decision of
> framework changes (which that codebase relied
> on) it all had to be rebased, I doubt that anyone
> would have reworked all that patch for patch. Instead it went into one
> repository and finally got modified to work again
> with the available framework rather than relying onto any such modifications.

One thing is to rebase a tree, another is to merge all patches into a big 
one, not preserving the original authorships.

Development trees sometimes need rebase. This is done by popping all newer 
patches from the tree, applying the upstream patches, and then pushing 
again every individual patches, fixing the ones that don't apply well, but 
preserving their authorships.

The modified patches should receive a special tag before the 
maintainer's SOB, like:

[me@mymail: I did this to apply this patch]

as stated at the kernel docs.

This method will reduce a lot the risk of breaking improvements and other 
fixes that happened upstream, and will properly preserve authorship of 
individual patches.

If you were doing a rebase, your patches would likely be accepted.

-- 
Cheers,
Mauro
