Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbZFCP3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbZFCP3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZFCP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:29:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:57401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZFCP3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:29:43 -0400
Date: Wed, 3 Jun 2009 08:25:58 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (staging)
Message-ID: <20090603152558.GA25725@suse.de>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <4A2695C1.2060104@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2695C1.2060104@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:24:49AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Looks like a real rush since -rc7 ...
> 
> 
> drivers/staging/comedi/drivers/adq12b.c:328: error: implicit declaration of function 'udelay'
> 
> 
> drivers/staging/mrst_nand/ffsport.c:360:error: 'struct request' has no member named 'sector'
> drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no member named 'sector'
> drivers/staging/mrst_nand/ffsport.c:376:error: 'struct request' has no member named 'current_nr_sectors'
> drivers/staging/mrst_nand/ffsport.c:380:error: 'struct request' has no member named 'sector'
> drivers/staging/mrst_nand/ffsport.c:381:error: 'struct request' has no member named 'current_nr_sectors'
> drivers/staging/mrst_nand/ffsport.c:392:error: 'struct request' has no member named 'current_nr_sectors'
> drivers/staging/mrst_nand/ffsport.c:499:error: implicit declaration of function 'elv_next_request'
> drivers/staging/mrst_nand/ffsport.c:517:error: implicit declaration of function 'end_request'
> drivers/staging/mrst_nand/ffsport.c:738:error: implicit declaration of function 'blk_queue_hardsect_size'

Can I get your .config for this?  It works here with a "default" one.

thanks,

greg k-h
