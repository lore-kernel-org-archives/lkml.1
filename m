Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXFKXts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXFKXts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXFKXtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:49:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbXFKXtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:49:40 -0400
Date: Mon, 11 Jun 2007 16:49:47 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
Message-ID: <20070611234947.GA20078@kroah.com>
References: <20070609000827.GA17624@kroah.com> <963615.80973.qm@web50105.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963615.80973.qm@web50105.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 04:30:11PM -0700, Doug Thompson wrote:
> 
> --- Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Jun 08, 2007 at 10:45:10AM -0600, dougthompson@xmission.com wrote:
> > > From:	Douglas Thompson <dougthompson@xmission.com>
> > > 
> > > pci_ids.h needs two of the AMD NB device-ids namely,
> > > Addressmap and the Memory Controller devices
> > 
> > Does any kernel driver need this?  We're trying to only include things
> > in the pci_ids.h file that are needed in more than one file to cut down
> > on the churn here for unnecessary ids.
> 
> not at the moment, but I have the k8_edac.c EDAC driver in my queue, which was in the -mm tree but
> I had to pull it back once.
> 
> I am working with the k8 driver and its dealing with a race with the mcelog device as both access
> the K8 NB. The K8 driver does use these regs and it currently has #ifndef s in it for both of
> them.
> 
> I guess I could have submitted the patch when the K8 driver was submitted.

That would be preferable, thanks.

greg k-h
