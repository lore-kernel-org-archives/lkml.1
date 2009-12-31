Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLaEvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLaEvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZLaEvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:51:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:55753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZLaEvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:51:47 -0500
Date: Wed, 30 Dec 2009 20:40:39 -0800
From: Greg KH <gregkh@suse.de>
To: Emese Revfy <re.emese@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
       rusty@rustcorp.com.au, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/1] Constify struct kset_uevent_ops for 2.6.33-rc2
Message-ID: <20091231044039.GB27927@suse.de>
References: <cover.1260663000.git.re.emese@gmail.com> <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com> <4B39AEB2.5040809@cs.helsinki.fi> <4B3A6D63.4070700@gmail.com> <20091230001131.GA19830@suse.de> <4B3BED7A.6020507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3BED7A.6020507@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:16:58AM +0100, Emese Revfy wrote:
> Greg KH wrote:
> > On Tue, Dec 29, 2009 at 09:58:11PM +0100, Emese Revfy wrote:
> >>>> I double checked both the declaration and definitions of the affected
> >>>> function/structure and they are consistently const here.
> >>>> Can you tell me what patch/tree combination you encountered this
> >>>> warning with?
> >>> 2.6.33-rc2 with your patch.
> >> Here is the updated patch for 2.6.33-rc2 in one piece.
> >> Emese
> >>
> >>
> >> From: Emese Revfy <re.emese@gmail.com>
> >>
> >> Constify struct kset_uevent_ops.
> > 
> > Why is this needed?  What does it accomplish?
> 
> This is my contribution to the ops structure constification effort
> that some developers started a few years ago (Arjan, Al Viro, etc.)
> and that has been worked on somewhat sporadically ever since. For a
> summary of why this is useful please see Arjan's email:
> http://lkml.org/lkml/2009/12/14/216

Then please insert this kind of information in the patch itself,
otherwise it is totally unknown.

Care to resend with the proper information in it?

thanks,

greg k-h
