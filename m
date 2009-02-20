Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZBTQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZBTQes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZBTQej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:34:39 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50231 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZBTQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:34:38 -0500
Subject: [GIT PULL] Btrfs patches for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 11:33:50 -0500
Message-Id: <1235147630.13249.21.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.499EDB74.0215:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

We're hammering on fixes for performance, stack reduction and enospc in
an experimental btrfs tree, but one of the things that fell out as a
stable patch is a fix for an oops on directory fsyncs from NFS.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (1):                                          
      Btrfs: check file pointer in btrfs_sync_file        


 file.c |    8 ++++----                                          
 1 file changed, 4 insertions(+), 4 deletions

-chris


