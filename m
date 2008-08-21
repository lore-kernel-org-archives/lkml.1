Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYHUUHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYHUUHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYHUUHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:07:42 -0400
Received: from mail.suse.de ([195.135.220.2]:40471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYHUUHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:07:41 -0400
Date: Thu, 21 Aug 2008 13:04:41 -0700
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/15] driver model: anti-oopsing medicine
Message-ID: <20080821200441.GA18318@suse.de>
References: <20080821173036.GB7974@suse.de> <1219339983-9634-6-git-send-email-gregkh@suse.de> <200808211124.22485.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808211124.22485.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:24:22AM -0700, David Brownell wrote:
> On Thursday 21 August 2008, Greg Kroah-Hartman wrote:
> > +       if (!class->p) {
> > +               WARN(1, "%s called for class '%s' before it was initialized",
> > +                    __func__, class->name);
> > +               return -EINVAL;
> > +       }
> 
> Or -- for future reference -- using WARN() with non-constant
> initial parameter:
> 
> 	if (WARN(!class-p, "%s called ...\n" ...))
> 		return -EINVAL;
> 
> Some of those macros now have return values, supportin C code
> that looks a bit more compact.

Ah, yeah, that looks much nicer, I'll remember that in the future.

thanks,

greg k-h
