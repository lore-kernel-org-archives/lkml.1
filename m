Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZL3A1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZL3A1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZL3A1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:27:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:44648 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZL3A1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:27:14 -0500
Date: Tue, 29 Dec 2009 16:11:31 -0800
From: Greg KH <gregkh@suse.de>
To: Emese Revfy <re.emese@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 1/1] Constify struct kset_uevent_ops for 2.6.33-rc2
Message-ID: <20091230001131.GA19830@suse.de>
References: <cover.1260663000.git.re.emese@gmail.com> <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com> <4B39AEB2.5040809@cs.helsinki.fi> <4B3A6D63.4070700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3A6D63.4070700@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 09:58:11PM +0100, Emese Revfy wrote:
> >> I double checked both the declaration and definitions of the affected
> >> function/structure and they are consistently const here.
> >> Can you tell me what patch/tree combination you encountered this
> >> warning with?
> > 
> > 2.6.33-rc2 with your patch.
> 
> Here is the updated patch for 2.6.33-rc2 in one piece.
> Emese
> 
> 
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct kset_uevent_ops.

Why is this needed?  What does it accomplish?

thanks,

greg k-h
