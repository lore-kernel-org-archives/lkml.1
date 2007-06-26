Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbXFZUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbXFZUAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759286AbXFZUAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:00:25 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25163 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758974AbXFZUAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:00:20 -0400
Date: Tue, 26 Jun 2007 15:59:52 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 12/12] the aoeminor doesn't need a long format
Message-ID: <20070626195952.GJ25729@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com> <e4b5ee94f03480b4801b4a1ddce2d5b71073e258.1182883861.git.ecashin@coraid.com> <20070626125107.ce2b4325.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626125107.ce2b4325.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 12:51:07PM -0700, Randy Dunlap wrote:
> On Tue, 26 Jun 2007 14:50:12 -0400 Ed L. Cashin wrote:
> 
> > The aoedev aoeminor member doesn't need a long format.
> 
> Was there a patch that changed aoeminor to an int?
> Last I see is:
> 	ulong aoeminor;
> in linux-2.6.22-rc6/drivers/block/aoe/aoe.h.
> 
> If it's still ulong, you shouldn't change the printk format.

Yes, thanks for checking.  Patch 2 of 12 did change it to a u16.

-- 
  Ed L Cashin <ecashin@coraid.com>
