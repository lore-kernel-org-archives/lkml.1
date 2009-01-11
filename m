Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZAKPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZAKPVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZAKPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:21:10 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:42449 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZAKPVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:21:09 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Subject: Re: current git kernel has strange problems during bisect
Date: Sun, 11 Jan 2009 16:20:03 +0100
User-Agent: KMail/1.9.9
Cc: git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de>
In-Reply-To: <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111620.03345.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Sonntag 11 Januar 2009 schrieben Sie:
> Hi,
> 
> On Sun, 11 Jan 2009, Christian Borntraeger wrote:
> 
> > Am Sonntag 11 Januar 2009 schrieb Christian Borntraeger:
> > > doing a 
> > > git bisect start
> > > git bisect good a3a798c
> > > git bisect bad v2.6.29-rc1
> > > 
> > > results in a repository without several files, e.g Makefile!
> > > git describe also fails.
> > 
> > In fact, retesting with a clean repository shows, that there are only 
btrfs 
> > files - nothing else.
> > 
> > Linus did you pull a broken btrfs repository?
> 
> I guess it is a subtree merge.  So no, nothing went wrong
> 
> Use "git bisect skip" to skip over those.

I think we should really avoid merging subtrees to the linux kernel. It makes 
bisecting a real PITA. 
Furthermore, It is unlikely, but what if the problem is part of the 581 
changesets from btrfs?

Christian
