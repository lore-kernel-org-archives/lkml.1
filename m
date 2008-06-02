Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYFBISP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYFBISP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbYFBIRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:17:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27243 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbYFBIRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:17:52 -0400
Date: Mon, 2 Jun 2008 10:17:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, Kyle McMartin <kyle@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 9/10] parisc: convert to generic helpers for IPI  function calls
Message-ID: <20080602081749.GG5757@kernel.dk>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-10-git-send-email-jens.axboe@oracle.com> <20080531070049.GA6623@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531070049.GA6623@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31 2008, Kyle McMartin wrote:
> On Thu, May 29, 2008 at 10:58:23AM +0200, Jens Axboe wrote:
> > This converts parisc to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single(). Not tested,
> > not even compiled.
> > 
> > Cc: Kyle McMartin <kyle@parisc-linux.org>
> > Cc: Matthew Wilcox <matthew@wil.cx>
> > Cc: Grant Grundler <grundler@parisc-linux.org>
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >  
> 
> Do you have all this in an easily accessible git tree that I can merge
> to test?

Yep, you can pull:

git://git.kernel.dk/linux-2.6-block.git generic-ipi

to get this patchset. I should have mentioned that in the intro
mail...

-- 
Jens Axboe

