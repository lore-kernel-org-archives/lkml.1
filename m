Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbXIBVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbXIBVAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXIBVAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:00:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbXIBVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:00:06 -0400
Date: Sun, 2 Sep 2007 13:59:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: kyler-keyword-lkml.9c0da5@lairds.com, linux-kernel@vger.kernel.org
Subject: Re: Fw: 2.6.23-rc3-mm1 UnionFS "BUG: atomic counter underflow"
Message-Id: <20070902135957.e0903bbe.akpm@linux-foundation.org>
In-Reply-To: <20070902164835.GA19580@filer.fsl.cs.sunysb.edu>
References: <20070902045634.fd2d2a5f.akpm@linux-foundation.org>
	<20070902164835.GA19580@filer.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2 Sep 2007 12:48:35 -0400 "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu> wrote:
> On Sun, Sep 02, 2007 at 04:56:34AM -0700, Andrew Morton wrote:
> > 
> > fyi..
>  
> I got a bunch of patches queued up that should fix a few things - quite
> possibly this one too.
> 
> I want to push the patches to korg, but in the mix is a fs/stack.c change &
> corresponding ecryptfs fix that should go to Linus's tree. The rest of the
> patches depend on this change.
> 
> How do you want me to do this? I guess I'll just send all of them to lkml,
> and say which ones should go where in the 00/xx mail.

Let's do that as a starting point.  Perhaps we can fast-track the ecryptfs
fix into mainline if it fixes something there.  

I don't want to kep the unionfs tree hanging around forever.  We need to
work out whether we want to merge it.
