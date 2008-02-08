Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYBHN1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYBHN1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYBHN1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:27:14 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61386 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYBHN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:27:12 -0500
Date: Fri, 08 Feb 2008 08:26:57 -0500
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3 freeze feature
In-reply-to: <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20080208132657.GE3120@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080125195938t-sato@mail.jp.nec.com>
 <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
 <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 08, 2008  19:48 +0900, Takashi Sato wrote:
> OK I would like to implement the freeze feature on VFS
> as the filesystem independent ioctl so that it can be
> available on filesystems that have already had write_super_lockfs()
> and unlockfs().
> The usage for the freeze ioctl is the following.
>  int ioctl(int fd, int FIFREEZE, long *timeval);
>    fd:file descriptor of mountpoint
>    FIFREEZE:request cord for freeze
>    timeval:timeout period (second)
>
> And the unfreeze ioctl is the following.
>  int ioctl(int fd, int FITHAW, NULL);
>    fd:file descriptor of mountpoint
>    FITHAW:Request cord for unfreeze

You may as well make the common ioctl the same as the XFS version,
both by number and parameters, so that applications which already
understand the XFS ioctl will work on other filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

