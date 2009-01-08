Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbZAHKGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbZAHKGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZAHKGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:06:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59782 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZAHKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:06:10 -0500
Date: Thu, 8 Jan 2009 11:08:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] w35und: Move ETH_LENGTH_OF_ADDRESS to wbhal_s.h
Message-ID: <20090108100810.GA7577@elf.ucw.cz>
References: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI> <1231408018.5539.6.camel@brick> <1231408613.9373.5.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231408613.9373.5.camel@penberg-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-08 11:56:53, Pekka Enberg wrote:
> On Thu, 2009-01-08 at 01:46 -0800, Harvey Harrison wrote:
> > On Thu, 2009-01-08 at 11:30 +0200, Pekka J Enberg wrote:
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > >  
> > > +#define ETH_LENGTH_OF_ADDRESS 6
> > 
> > Or just use ETH_ALEN like the rest of the kernel and drop this guy.
> 
> Even better, thanks Harvey! Greg, please use this one instead. The rest
> of the series is unaffected by the changes in this patch.
> 
> >From c849ed5b5e68953a72f8dc43066513f118822f94 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Thu, 8 Jan 2009 11:10:06 +0200
> Subject: [PATCH] w35und: convert code to use ETH_ALEN
> 
> As suggested by Harvey Harrison, convert driver to use ETH_ALEN and kill a
> private macro from common.h that is used for the same thing.
> 
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
