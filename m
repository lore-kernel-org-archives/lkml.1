Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXJDJRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXJDJRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXJDJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbXJDJRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:14 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [GFS2/DLM] Pre-pull patch posting
Date: Thu,  4 Oct 2007 09:48:53 +0100
Message-Id: <11914877842142-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since it seems that another merge window will probably be opening shortly
this is a posting of the current content of the GFS2/DLM -nmw git tree.

There are no new features this time, its all fixes and cleanups. I have
a few patches that I'm holding back which I'm intending to start off
the new -nmw git tree with after this merge, those include:

 o Patch to use page_mkwrite() on page faults (and thus allow us to
   use the filemap_fault() function rather than having a special
   GFS2 version of this like we do at the moment)
 o Patch to clean up gfs2_internal_read() as requested by Christoph
   Hellwig
 o Patches to separate the GFS2 aops into three separate operations
   structures (for writeback, ordered & jdata) as per ext3 which is
   waiting for the merge of Nick Piggin's AOP changes so that I don't
   land up creating a merge conflict.

Anyhow, back to what is in this set of patches... the major area of
change is the journalling code where there has been a lot of clean
up. Other than that, its mostly fixes for individual bugs and clean
ups that other people have sent to me,

Steve.


