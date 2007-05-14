Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXENJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXENJa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbXENJaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:30:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37896 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXENJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:30:15 -0400
Date: Mon, 14 May 2007 15:07:22 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  0/14] VFS based Union Mount(v1)
Message-ID: <20070514093722.GB4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another post of vfs based union mount implementation.
Union mount provides the filesytem namespace unification feature.
Unlike the traditional mounts which hide the contents of the mount point,
the union mount presents the merged view of the mount point and the
mounted filesytem.

These patches were originally by Jan Blunck. The current patches are for
2.6.21-mm1. The main change from the previous post is a different implementation
of union mount readdir which is heavily inspired by the unionfs' implementation.
The earlier version had two serious drawbacks: It worked only for filesystems
which had flat file directories and it used to build and destroy readdir cache
for every readdir() call. This version has addressed both of these shortcomings.

The code is still in an experimental stage and the intention of posting this
now is to get some initial feedback about the design and the future directions
about how this should be taken forward.

You can find more details about union mount in the documentation
included in the patchset.

Kindly review and let us know your comments.

Regards,
Bharata.
