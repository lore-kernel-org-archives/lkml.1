Return-Path: <linux-kernel-owner+w=401wt.eu-S1161717AbXDXLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161717AbXDXLox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161714AbXDXLox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:44:53 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:46170 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161697AbXDXLow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:44:52 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.60841.900376.524639@gargle.gargle.HOWL>
Date: Tue, 24 Apr 2007 15:44:41 +0400
To: Amit Gud <gud@cis.ksu.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, suparna@in.ibm.com, brandon@ifup.org,
       karunasagark@gmail.com, gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Newsgroups: gmane.linux.file-systems,gmane.linux.kernel
In-Reply-To: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Gud writes:

Hello,

 > 
 > This is an initial implementation of ChunkFS technique, briefly discussed
 > at: http://lwn.net/Articles/190222 and 
 > http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf

I have a couple of questions about chunkfs repair process. 

First, as I understand it, each continuation inode is a sparse file,
mapping some subset of logical file blocks into block numbers. Then it
seems, that during "final phase" fsck has to check that these partial
mappings are consistent, for example, that no two different continuation
inodes for a given file contain a block number for the same offset. This
check requires scan of all chunks (rather than of only "active during
crash"), which seems to return us back to the scalability problem
chunkfs tries to address.

Second, it is not clear how, under assumption of bugs in the file system
code (which paper makes at the very beginning), fsck can limit itself
only to the chunks that were active at the moment of crash.

[...]

 > 
 > Best,
 > AG

Nikita.
