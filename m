Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYGHPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYGHPul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYGHPud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:50:33 -0400
Received: from q7.q7.com ([207.173.201.42]:43766 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYGHPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:50:33 -0400
X-Greylist: delayed 1671 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2008 11:50:32 EDT
Date: Tue, 8 Jul 2008 08:22:25 -0700
From: Ian Romanick <ianr@q7.com>
To: Mark Asselstine <asselsm@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm_memory.h: remove double inclusion of linux/vmalloc.h
Message-ID: <20080708152225.GA9028@q7.q7.com>
References: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com> <919fe2b30807080529j71ae1816sc035c90b5eee555c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <919fe2b30807080529j71ae1816sc035c90b5eee555c@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 08:29:57AM -0400, Mark Asselstine wrote:
> On Sun, Jul 6, 2008 at 7:31 AM, Alexander Beregalov
> <a.beregalov@gmail.com> wrote:
> > From: Alexander Beregalov <a.beregalov@gmail.com>
> >
> >  #if __OS_HAS_AGP
> >
> > -#include <linux/vmalloc.h>
> > -
> 
> Why remove this one and not the one at the top of the file? As well

I would assume this one is removed because it is inside additional
ifdefs.

> this file has #include of drmP.h, yet drmP.h is the only file I can
> find that includes drm_memory.h. Based on this I would think there is
> some additional cleanup that can go on here.

