Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYCaUf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYCaUf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYCaUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:35:21 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3888 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYCaUfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:35:20 -0400
Date: Mon, 31 Mar 2008 14:35:17 -0600
From: Alex Chiang <achiang@hp.com>
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080331203517.GE341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331202633.GA341@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> 
> I've gotten as far as successfully creating a btrfs filesystem
> (at least that's what btrfsck tells me), but haven't been able to
> mount it yet, probably because of the sector size issue.

Oh, and for those curious, here's the output of btrfsck:

[root@canola btrfs-progs-unstable]# btrfsck /dev/cciss/c2d1
found device 1 on /dev/cciss/c2d1
lowest devid now 1
found Btrfs on /dev/cciss/c2d1 with 1 devices
opening /dev/cciss/c2d1 devid 1 fd 4
found 102400 bytes used err is 0
total csum bytes: 0
total tree bytes: 81920
btree space waste bytes: 79462
file data blocks allocated: 0
 referenced 0


[yes, that's working over the cciss block device ;)]

/ac

