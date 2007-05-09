Return-Path: <linux-kernel-owner+w=401wt.eu-S970918AbXEIAAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970918AbXEIAAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970645AbXEIAAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:00:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42256 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970442AbXEIAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:00:08 -0400
Date: Tue, 8 May 2007 17:01:01 -0700
From: Greg KH <greg@kroah.com>
To: J??rn Engel <joern@lazybastard.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070509000101.GB3967@kroah.com>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com> <20070508205827.GC23056@lazybastard.org> <20070508225253.GA2689@kroah.com> <20070508231009.GB25920@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508231009.GB25920@lazybastard.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:10:09AM +0200, J??rn Engel wrote:
> 
> The remaining question is how to deal with kernel-only code that uses
> be64.  Convert that to __be64 as well?  Or introduce be64 in
> include/linix/types.h instead?

I say leave it alone for now, it's not that common :)

thanks,

greg k-h
