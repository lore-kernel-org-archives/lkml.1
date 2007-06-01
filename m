Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbXFAT5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbXFAT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbXFAT5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:57:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37099 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762108AbXFAT5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:57:42 -0400
Date: Fri, 1 Jun 2007 20:57:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601195738.GA21537@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	andrew.vasquez@qlogic.com
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601193703.GI7217@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:37:03PM +0200, Andi Kleen wrote:
> > in some cases which is highly annoying and leads people to stick a
> > __GFP_NOWARN into various places)
> 
> An pci_map_sg failing typically leads to an IO error and we've
> always printk'ed those. Otherwise people will wonder why they
> get EIO.

Not in a scsi driver.  It will get requeued and the midlayer will submit
it again when an outstanding command has finished.

