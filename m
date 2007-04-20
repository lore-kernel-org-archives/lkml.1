Return-Path: <linux-kernel-owner+w=401wt.eu-S1767313AbXDTXCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767313AbXDTXCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767312AbXDTXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:02:12 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:58608 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767308AbXDTXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:02:11 -0400
Date: Fri, 20 Apr 2007 17:02:08 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] fix ext2 allocator overflows above 31 bit blocks
Message-ID: <20070420230208.GU5967@schatzie.adilger.int>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
References: <4628F3ED.9040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628F3ED.9040101@redhat.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20, 2007  12:10 -0500, Eric Sandeen wrote:
> If ext3 can do 16T, ext2 probably should be able to as well.
> There are still "int" block containers in the block allocation path
> that need to be fixed up.

Yeah, but who wants to do 16TB e2fsck on every boot?  I think there
needs to be some limits imposed for the sake of usability.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

