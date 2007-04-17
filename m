Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXDQNHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXDQNHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXDQNHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:07:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45328 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbXDQNHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:07:42 -0400
Date: Tue, 17 Apr 2007 18:44:59 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  0/15] VFS based Union Mount
Message-ID: <20070417131459.GA4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an attempt towards vfs based union mount implementation.
Union mount provides the filesytem namespace unification feature.
Unlike the traditional mounts which hide the contents of the mount point,
the union mount presents the merged view of the mount point and the
mounted filesytem.

These patches were originally developed for 2.6.11 by Jan Blunck and
lately we have been working together in taking this forward. The current
patchset applies against 2.6.21-rc6-mm1.

The code is in a highly experimental stage at the moment and the intention
of posting this now is to get some initial feedback about the design
and the future directions about how this should be taken forward.

You can find more details about union mount in the documentation
included in the patchset.

Kindly review and let us know your comments.

Regards,
Bharata.
