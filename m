Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbXBEN7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbXBEN7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbXBEN7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:59:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590AbXBEN7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:59:05 -0500
Subject: [GFS2 & DLM] Proposed patches for 2.6.20 merge window [0/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:07:05 +0000
Message-Id: <1170684425.11001.267.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following this message are the patches which currently make up the GFS2
-nmw (next merge window) git tree. Mostly they are bug fixes and clean
ups, but there are one or two other changes, the highlights being:

 [26/54] Changes "writeback" mounts to not require buffer heads in
writepages and also results in fewer I/Os.
 [29/54] This is probably the most notable since it effectively shrinks
the amount of memory per struct gfs2_inode by half.
 [27/54] Removes the attempt at directory readahead in readdir and
results in a substantial speed improvement for readdir without noticably
slowing readdir+stat performance.

Steve.


