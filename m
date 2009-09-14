Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZINGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZINGZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZINGZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:25:40 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:60675 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751524AbZINGZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:25:40 -0400
Date: Mon, 14 Sep 2009 00:25:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
Message-ID: <20090914062520.GB23467@obsidianresearch.com>
References: <20090902031613.GA11464@obsidianresearch.com> <20090903165219.2f79cdc1.akpm@linux-foundation.org> <20090904012818.GU4973@obsidianresearch.com> <alpine.LRH.2.00.0909141236020.28766@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909141236020.28766@tundra.namei.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:36:39PM +1000, James Morris wrote:
> On Thu, 3 Sep 2009, Jason Gunthorpe wrote:

> > > That sounds like a fairly serious bug, and this looks like a 2.6.31
> > > patch.
> 
> Any comments from the maintainers on this patch?

FWIW, I didn't mention in the patch emails, but all the patches I sent
fix regressions that have been introduced in the past couple years by
clean up patches that never tested the code paths they alter.

What becomes of patches that end up in the mm tree? Do they still
route through you for mainline inclusion?

Thanks for looking at this.

Jason
