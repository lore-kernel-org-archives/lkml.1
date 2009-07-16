Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbZGPW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbZGPW4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbZGPW4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:56:04 -0400
Received: from kroah.org ([198.145.64.141]:33381 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbZGPW4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:56:02 -0400
Date: Thu, 16 Jul 2009 15:50:24 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090716225024.GA22375@kroah.com>
References: <20090714163309.f2ee320d.sfr@canb.auug.org.au>
 <200907140031.27979.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907140031.27979.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:31:27AM -0700, David Brownell wrote:
> On Monday 13 July 2009, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/mtd/mtdcore.c:220: error: expected '{' before 'const'
> > drivers/mtd/mtdcore.c:227: error: 'mtd_groups' undeclared here (not in a function)
> > 
> > Caused by the update to commit ba87b739a1f5dd545679d886b8d193cdede991cf
> > ("driver model: constify attribute groups").
> > 
> > I have applied the patch below for today.
> 
> That's a good patch, go with it.  Sorry; I guess this wasn't
> the version I had test-built.  My eyes were reporting "static"
> as the (expected) initial keyword there; they lied!

I've merged this with your original one, thanks.

greg k-h
