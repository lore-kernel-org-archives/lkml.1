Return-Path: <linux-kernel-owner+w=401wt.eu-S936242AbXGSX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242AbXGSX6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbXGSX63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:58:29 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:60931 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbXGSX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:58:27 -0400
Date: Thu, 19 Jul 2007 17:58:25 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com,
       dgc@sgi.com, michael.kerrisk@gmx.net
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Message-ID: <20070719235825.GY5992@schatzie.adilger.int>
Mail-Followup-To: Mark Fasheh <mark.fasheh@oracle.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, dgc@sgi.com,
	michael.kerrisk@gmx.net
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com> <20070719034155.GE32734@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719034155.GE32734@ca-server1.us.oracle.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2007  20:41 -0700, Mark Fasheh wrote:
> On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> > After a successful call, subsequent writes are guaranteed not to fail
> > because of lack of disk space.
>   
> If a write to an unwritten region requires a node split, that could result
> in the allocation of new meta data which obviously could fail if the disk is
> truly full.
> 
> Granted that's unlikely to happen but maybe we should be conservative and
> say something like:
> 
> "After a successful call, subsequent writes are guaranteed to never require
> allocation of file data." ?
>         --Mark

In the worst case, the unwritten extent could be zero-filled before the write
is done, so no exent split is needed.  We discussed this recently for the
ext4 fallocate, but didn't consider it important enough to hold the code.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

