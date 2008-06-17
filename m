Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYFQOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYFQOpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYFQOpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:45:41 -0400
Received: from lazybastard.de ([212.112.238.170]:51661 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbYFQOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:45:40 -0400
Date: Tue, 17 Jun 2008 16:45:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080617144526.GA28448@logfs.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr> <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr> <20080617105300.GA28310@logfs.org> <20080617160628.79efd2d9@mercedes-benz.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080617160628.79efd2d9@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 June 2008 16:06:28 +0200, Maxim Shchetynin wrote:
> > 
> > My personal question when looking at this is: Why not use ext2?  It
> 
> Same reason we don't use ext2 for file system in RAM - we don't need any expensive caching and readahead mechanisms for devices which are as fast as main memory (or almost as fast).

Well, with the '-o xip' option I mentioned below, there is no caching or
readahead.  The direct_access method you use as well was developed for
ext2.  Or rather for xip2fs, another new filesystem.  After some review,
that was shot down and a mount option was added to ext2 instead.

> > appears to me that an ext2 mounted with '-o xip' would solve the same
> > problems.

Jörn

-- 
Homo Sapiens is a goal, not a description.
-- unknown
