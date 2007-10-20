Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbXJTGET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbXJTGET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXJTGEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:04:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXJTGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:03:59 -0400
Date: Fri, 19 Oct 2007 23:07:13 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
Message-ID: <20071020060713.GB12130@kroah.com>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 03:54:43AM -0400, Jeff Garzik wrote:
> 
> The overwhelming majority of drivers do not ever bother with the 'irq'
> argument that is passed to each driver's irq handler.
> 
> Of the minority of drivers that do use the arg, the majority of those
> have the irq number stored in their private-info structure somewhere.
> 
> There are a tiny few -- a couple Mac drivers -- which do weird things
> with that argument, but that's it.
> 
> For the large sweeps through the tree, these patches are grouped into
> "trivial" changes -- simply removing the unused irq arg -- or all other
> changes.

Very cool stuff, I like it :)

greg k-h
