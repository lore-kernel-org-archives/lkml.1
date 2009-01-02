Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZABTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZABTk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZABTkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:40:14 -0500
Received: from acsinet14.oracle.com ([141.146.126.236]:59871 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZABTkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:40:13 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <20090103.013755.42849152.ryusuke@osrg.net>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 14:38:07 -0500
Message-Id: <1230925087.7538.41.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet11.oracle.com [141.146.126.233]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.495E6D99.01A7:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> Hi,
> On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > This has only btrfs as a module and would be the fastest way to see
> > the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
> > fs/Kconfig

[ ... ]

> In addition, there seem to be well-separated reusable routines such as
> async-thread (enhanced workqueue) and extent_map.  Do you intend to
> move these into lib/ or so?

Sorry, looks like I hit send too soon that time.  The async-thread code
is very self contained, and was intended for generic use.  Pushing that
into lib is probably a good idea.

The extent_map and extent_buffer code was also intended for generic use.
It needs some love and care (making it work for blocksize != pagesize)
before I'd suggest moving it out of fs/btrfs.

-chris


