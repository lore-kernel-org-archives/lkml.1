Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbXFGR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbXFGR0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763705AbXFGR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:26:10 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53873 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763736AbXFGR0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:26:09 -0400
Date: Thu, 7 Jun 2007 13:25:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       akpm@linux-foundation.org, david@dgreaves.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA commands
Message-ID: <20070607172507.GB11882@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org> <20070606160511.GA23143@havoc.gtf.org> <46683E4D.9060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46683E4D.9060801@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:20:13PM -0400, Chuck Ebbert wrote:
> On 06/06/2007 12:05 PM, Jeff Garzik wrote:
> > FYI to all -- 
> > 
> > As a reminder. the Promise hardware programs registers when it receives
> > a SET FEATURES - XFER MODE.
> > 
> > If data transfer is occurring on OTHER ports at the time this is issued,
> > then data corruption is guaranteed to occur.  Polling will not fix this
> > problem -- all ports need to be inactive, when a SET FEATURES - XFER
> > MODE command is issued for any port.

> So is this patch OK but yet more work needs to be done, or does
> this patch cause new problems?

Causes no /new/ problems...  :)  The existing problem described above
remains.

	Jeff



