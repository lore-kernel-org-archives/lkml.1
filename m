Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYFQKxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYFQKxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYFQKxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:53:46 -0400
Received: from lazybastard.de ([212.112.238.170]:48068 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYFQKxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:53:45 -0400
Date: Tue, 17 Jun 2008 12:53:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Maxim Shchetynin <maxim@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080617105300.GA28310@logfs.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr> <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 June 2008 11:35:10 +0200, Jan Engelhardt wrote:
> On Tuesday 2008-06-17 11:06, Maxim Shchetynin wrote:
> 
> >I would say you can either mmap it or place a file system on it.
> 
> The help text implies that I *need* azfs to mmap it - and that sounds
> like a Rube Goldberg machine.

Some people actually prefer filesystems over raw devices for a variety
of reasons:
- each file brings its own address space, which offers memory protection
  from other processes,
- files can have owners and permission bits,
- files hide the fragmentation of the underlying device from users,
- a file system provides a common and well-understood api for devices
  with less common or well-understood apis,
- etc.

Those reasons are as valid for azfs as for any other filesystem.  I have
no doubt that azfs is useful.  It probably wouldn't hurt to express the
merits of the filesystem and the problems it is supposed to solve a
little better.  So far most criticism was based on the fact that noone
understood what the hell it was all about.

My personal question when looking at this is: Why not use ext2?  It
appears to me that an ext2 mounted with '-o xip' would solve the same
problems.

Jörn

-- 
To announce that there must be no criticism of the President, or that we
are to stand by the President, right or wrong, is not only unpatriotic
and servile, but is morally treasonable to the American public.
-- Theodore Roosevelt, Kansas City Star, 1918
