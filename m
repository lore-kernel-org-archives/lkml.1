Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXHBFYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXHBFYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXHBFYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:24:44 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:43711 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXHBFYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:24:43 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC 12/26] ext2 white-out support
Date: Thu, 2 Aug 2007 07:24:39 +0200
User-Agent: KMail/1.9.7
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
References: <20070730161323.100048969@weierstrass.suse.de> <1185981810.18007.14.camel@kleikamp.austin.ibm.com> <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
In-Reply-To: <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708020724.40623.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 1. August 2007, Josef Sipek wrote:
> Alright not the greatest of examples, there is something to be said about
> symmetry, so...let me try again :)
...
> Oops! There's a whiteout in /b that hides the directory in /c -- rename(2)
> shouldn't make directory subtrees disappear.
>
> There are two ways to solve this:
>
> 1) "cp -r" the entire subtree ...
>
> 2) Don't store whiteouts within branches ...
Sorry for making uninformed guesses, but if there are already special nodes 
(whiteout), why not extending them to some more general format - specifying a 
(source, destination) pair at the topmost level?
- A delete is a (source, NULL) pair
- A rename is a (source, destination) pair, which causes lookups on source to
  use the string destination in the lower branches.


Would that work?


Regards,

Phil

