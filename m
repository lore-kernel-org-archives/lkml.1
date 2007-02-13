Return-Path: <linux-kernel-owner+w=401wt.eu-S1750708AbXBMOyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750708AbXBMOyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbXBMOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:54:11 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63119 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXBMOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:54:11 -0500
Date: Tue, 13 Feb 2007 14:53:55 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       vince@arm.linux.org.uk
Subject: Re: [PATCH] mfd: SM501 core driver (#2)
Message-ID: <20070213145355.GA27437@fluff.org.uk>
References: <20070212110741.GA13208@trinity.fluff.org> <20070213115651.GA25015@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213115651.GA25015@roarinelk.homelinux.net>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 12:56:51PM +0100, Manuel Lauss wrote:
> Hi Ben,
> 
> On Mon, Feb 12, 2007 at 11:07:41AM +0000, Ben Dooks wrote:
> > This is a new release of the SM501 MFD driver.
> 
> > +struct sm501_platdata_fbsub {
> > +	struct fb_mode		*def_mode;
> > +	unsigned long		 max_mem;
> > +	unsigned int		 flags;
> > +};
> 
> This may be a very dumb question, but where is 'struct fb_mode' declared?
> I grepped through 2.6.19 and 2.6.20 (vanilla) and the closest matches
> found are struct fb_modelist and struct fb_videomode.

It should have been fb_videomode. It is there for passing throug a
default mode from a machine's platform data.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
