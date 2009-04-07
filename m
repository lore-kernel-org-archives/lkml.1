Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZDGSkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZDGSkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZDGSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:39:55 -0400
Received: from kroah.org ([198.145.64.141]:52804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754035AbZDGSjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:39:54 -0400
Date: Tue, 7 Apr 2009 11:28:55 -0700
From: Greg KH <greg@kroah.com>
To: Christopher Harrer <charrer@alacritech.com>
Cc: "'Lior Dotan'" <liodot@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  SLICOSS - use gfp_kernel where possible
Message-ID: <20090407182854.GB27973@kroah.com>
References: <4992B7EE.8020601@gmail.com> <019E07F7ABD24C5A9F79702ADD7F8230@exton.alacritech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019E07F7ABD24C5A9F79702ADD7F8230@exton.alacritech.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:31:14PM -0400, Christopher Harrer wrote:
> > -----Original Message-----
> > From: Lior Dotan [mailto:liodot@gmail.com] 
> > Sent: Wednesday, February 11, 2009 6:35 AM
> > To: gregkh@suse.de
> > Cc: Christopher Harrer; linux-kernel@vger.kernel.org
> > Subject: [PATCH] SLICOSS - use gfp_kernel where possible
> > 
> > Use GFP_KERNEL instead of GFP_ATOMIC where possible.
> > 
> > Signed_off-by: Lior Dotan <liodot@gmail.com>
> > 
> > 
> > 
> Hi Greg,
> 
> In speaking with Lior, would it be possible to revert this patch?  It's
> causing:
> 
> > Mar 24 11:50:31 linuxdev kernel: BUG: sleeping function called from 
> > invalid context at mm/slub.c:1599 Mar 24 11:50:31 linuxdev kernel: 
> > in_atomic(): 1, irqs_disabled(): 0, pid:
> > 3251, name: avahi-daemon
> 
> Please let me know if you need any additional information or have any
> questions.

Now reverted, sorry for the delay.

greg k-h
