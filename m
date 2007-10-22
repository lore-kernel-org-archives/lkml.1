Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbXJVGyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbXJVGyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXJVGx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:53:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50399 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbXJVGx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:53:57 -0400
Date: Mon, 22 Oct 2007 12:23:52 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] Use struct path in struct nameidata
Message-ID: <20071022065352.GA6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Could you please consider these patches for -mm ? These patches
apply on 2.6.23-mm1 and are mostly a repost of earlier patches.

Patches 1 to 11 have been Acked by Christoph Hellwig.

Patch 12 is another instance where (vfsmnt, dentry) to path conversion
is possible.

Patch 13 is a patch which renames d_path to print_path and fixes
comments as suggested by Christoph.

Compile and boot tested on x86, x86_64 and powerpc.

Regards,
Bharata.
