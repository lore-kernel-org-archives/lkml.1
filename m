Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYDGSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYDGSXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYDGSXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:23:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40617 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDGSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:23:04 -0400
Date: Mon, 7 Apr 2008 19:26:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <1207591482.3838.11.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0804071925110.18473@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <1207524935.3223.39.camel@localhost.localdomain>  <Pine.LNX.4.64.0804070145550.28303@blonde.site>
  <Pine.LNX.4.64.0804071844350.14273@blonde.site> <1207591482.3838.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, James Bottomley wrote:
> On Mon, 2008-04-07 at 18:51 +0100, Hugh Dickins wrote:
> > 
> > Somewhat irrelevant since Linus put my patch into 2.6.25-rc8-git
> > (probably worth it for the various issues noted in the comment);
> > but reassuring for 2.6.26.
> 
> Well ... just remember that to merge scsi-misc with what Linus has now
> done, I'm effectively reversing your patch, so testing current scsi-misc
> is very valuable if you want the problem not to recur in 2.6.26 ...

Exactly.

Hugh
