Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXFMDqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXFMDqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXFMDq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:46:27 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:62168 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXFMDq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:46:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18031.26764.586958.632146@stoffel.org>
Date: Tue, 12 Jun 2007 23:46:20 -0400
From: "John Stoffel" <john@stoffel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <20070612161029.GB28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

Chris> After the last FS summit, I started working on a new filesystem
Chris> that maintains checksums of all file data and metadata.  Many
Chris> thanks to Zach Brown for his ideas, and to Dave Chinner for his
Chris> help on benchmarking analysis.

Chris> The basic list of features looks like this:

Chris> 	* Extent based file storage (2^64 max file size)
Chris> 	* Space efficient packing of small files
Chris> 	* Space efficient indexed directories
Chris> 	* Dynamic inode allocation
Chris> 	* Writable snapshots
Chris> 	* Subvolumes (separate internal filesystem roots)
Chris> 	- Object level mirroring and striping
Chris> 	* Checksums on data and metadata (multiple algorithms available)
Chris> 	- Strong integration with device mapper for multiple device support
Chris> 	- Online filesystem check
Chris> 	* Very fast offline filesystem check
Chris> 	- Efficient incremental backup and FS mirroring

So, can you resize a filesystem both bigger and smaller?  Or is that
implicit in the Object level mirroring and striping?  

As a user of Netapps, having quotas (if only for reporting purposes)
and some way to migrate non-used files to slower/cheaper storage would
be great.

Ie. being able to setup two pools, one being RAID6, the other being
RAID1, where all currently accessed files are in the RAID1 setup, but
if un-used get migrated to the RAID6 area.  

And of course some way for efficient backups and more importantly
RESTORES of data which is segregated like this.  

John
