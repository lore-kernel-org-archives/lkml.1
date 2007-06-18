Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXFROpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXFROpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763074AbXFROpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:45:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30250 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763059AbXFROpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:45:21 -0400
Date: Mon, 18 Jun 2007 10:41:21 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070618144121.GD2061@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070612161029.GB28279@think.oraclecorp.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 12:10:29PM -0400, Chris Mason wrote:
> Hello everyone,
> 
> After the last FS summit, I started working on a new filesystem that
> maintains checksums of all file data and metadata.  Many thanks to Zach
> Brown for his ideas, and to Dave Chinner for his help on 
> benchmarking analysis.

Thanks to everyone that tried out btrfs.  Most of those that did managed
to hit problems with apps that did writes via mmap.  So, I added a
page_mkwrite call and worked out cow safe mmap writes.  

Terje Røsten sent along a btrfsprogs patch so that it compiles properly
on FC7 (thanks!).

I'll have a site up on oss.oracle.com/projects with mailing lists and
links to my HG trees shortly.  Until then:

http://oss.oracle.com/~mason/btrfs/ has the latest tar balls.

-chris
