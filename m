Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbXFSJMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbXFSJMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXFSJMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:12:24 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:4880 "EHLO
	sc-analyser1.mxsweep.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755426AbXFSJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:12:23 -0400
Message-ID: <46779DB1.7060807@draigBrady.com>
Date: Tue, 19 Jun 2007 10:11:13 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net>
In-Reply-To: <4676C2D6.8030708@vlnb.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.3.8711
X-Mlf-UniqueId: o200706190912490143318
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin wrote:
> 
> I would also suggest one more feature: support for block level
> de-duplication. I mean:
> 
> 1. Ability for Btrfs to have blocks in several files to point to the
> same block on disk
> 
> 2. Support for new syscall or IOCTL to de-duplicate as a single
> transaction two or more blocks on disk, i.e. link them to one of them
> and free others
> 
> 3. De-de-duplicate blocks on disk, i.e. copy them on write
> 
> I suppose that de-duplication itself would be done by some user space
> process that would scan files, determine blocks with the same data and
> then de-duplicate them by using syscall or IOCTL (2).
> 
> That would be very usable feature, which in most cases would allow to
> shrink occupied disk space on 50-90%.

Have you references for this number?
In my experience one gets a lot of benefit from
the much simpler process of "de-duplication" of files.

Note a checksum stored in file metadata,
that is automatically invalidated on write would
speed up user space file de duplification,
and rsync, etc....

Pádraig.
