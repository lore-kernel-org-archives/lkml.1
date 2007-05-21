Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbXEUOH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbXEUOH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXEUOHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:07:51 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2183 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXEUOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:07:50 -0400
Date: Mon, 21 May 2007 15:07:46 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.21: nfs_readpages: Add missing braces
In-Reply-To: <1179753845.6535.9.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64N.0705211501530.8263@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0705211402170.8263@blysk.ds.pg.gda.pl>
 <1179753845.6535.9.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Trond Myklebust wrote:

> > A change a while ago added a call to gather statistics to a conditional 
> > statement, but braces were missed on that occasion resulting in a change 
> > of semanticts.  This a change to rectify.
> 
> So you are proposing this as a stable update? It won't apply on
> 2.6.22-rc2.

 I have tried the patch on 2.6.21 and have missed the function in question 
has been since updated.  Sorry about that.  If you think the change is 
important-enough to be applied on a stable branch, the please go ahead, 
otherwise feel free to discard it.

  Maciej
