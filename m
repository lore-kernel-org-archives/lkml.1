Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXHBMMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXHBMMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbXHBMMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:12:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:35398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbXHBMMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:12:05 -0400
Date: Thu, 2 Aug 2007 14:12:03 +0200
From: Jan Blunck <jblunck@suse.de>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802121203.GZ5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <1185981810.18007.14.camel@kleikamp.austin.ibm.com> <20070801184405.GA18405@filer.fsl.cs.sunysb.edu> <200708020724.40623.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708020724.40623.philipp.marek@bmlv.gv.at>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, Ph. Marek wrote:

> On Mittwoch, 1. August 2007, Josef Sipek wrote:
> > Alright not the greatest of examples, there is something to be said about
> > symmetry, so...let me try again :)
> ...
> > Oops! There's a whiteout in /b that hides the directory in /c -- rename(2)
> > shouldn't make directory subtrees disappear.
> >
> > There are two ways to solve this:
> >
> > 1) "cp -r" the entire subtree ...
> >
> > 2) Don't store whiteouts within branches ...
> Sorry for making uninformed guesses, but if there are already special nodes 
> (whiteout), why not extending them to some more general format - specifying a 
> (source, destination) pair at the topmost level?
> - A delete is a (source, NULL) pair
> - A rename is a (source, destination) pair, which causes lookups on source to
>   use the string destination in the lower branches.

Originally I had the idea that whiteouts are a special kind of symlink. After
discussing that with various people sticked to the simplest approach.
