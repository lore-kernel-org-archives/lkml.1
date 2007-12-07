Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXLGCU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXLGCU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXLGCUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:20:49 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47896 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbXLGCUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:20:49 -0500
Date: Thu, 6 Dec 2007 21:20:41 -0500
Message-Id: <200712070220.lB72Kfqw004530@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: NFSv2/3 broken exporting/mounting (permission denied) in 2.6.24-rc4
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get a "permission denied" when trying to mount a localhost nfsv2/3
exported volume, on v2.6.24-rc4-124-gf194d13.  It works w/ nfsv4 mounting.
It worked fine in 2.6.24-rc3.  Here's a sequence of ops I tried:

# mount -t ext2 /dev/hdb1 /n/lower/b0
# exportfs -o no_root_squash,rw localhost:/n/lower/b0
# mount -t nfs -o nfsvers=3 localhost:/n/lower/b0 /mnt

Erez.
