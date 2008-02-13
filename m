Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbYBMB0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbYBMB0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYBMB0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:26:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59787 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYBMB0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:26:11 -0500
In-Reply-To: <20080212.152652.217936905.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: btrfs-devel@oss.oracle.com, chris.mason@oracle.com,
       jengelh@computergmbh.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: BTRFS partition usage...
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF91619394.99460343-ON882573EE.0006CBE5-882573EE.0007D541@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Tue, 12 Feb 2008 17:25:32 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 02/12/2008
 20:26:07,
	Serialize complete at 02/12/2008 20:26:07
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Sun disk label only allows you to specify the start of a partition
> in cylinders, so if you want to use a filesystem like XFS you have to
> start the partition on cylinder 1 which can be many blocks into the
> disk.  That entire first cylinder is completely wasted.

I don't believe a cylinder of wasted disk space is significant.  I don't 
believe a cylinder of disk is worth adding the complexity of sharing a 
partition to a filesystem.  That complexity translates into engineering 
time and mistakes.

Your other arguments for making a hole in the filesystem, based on 
tradition, are more convincing.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

