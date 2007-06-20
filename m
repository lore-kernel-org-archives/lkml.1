Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbXFTFnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbXFTFnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXFTFnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:43:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60141 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbXFTFnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:43:39 -0400
Date: Wed, 20 Jun 2007 11:20:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC PATCH 0/4] New approach to VFS based union mount
Message-ID: <20070620055050.GB4267@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The earlier approach to VFS based union mounts posted here didn't work for
all cases of mounts (specially bind mounts). Hence, I have worked on this
new approach which is more generic and hopefully should work in most cases.
This approach fundamentally changes the way union stacks are maintained.

Details of the approach can be found in the accompanying documentation patch.
Since this is still a work in progress, there are many loose ends. Apart
from that, I have some questions about the design and implementation aspects,
which I have raised in the documenation patch. It will be very helpful
if people who are familiar with VFS and stackable filesystems could review
this.

This series (on 2622rc4mm2) has the following 4 patches:

1/4 - Union mount documentation.
2/4 - Mount changes to support union mount.
3/4 - Lookup changes to support union mount.
4/4 - Directory listing support for union mounted directories.

Kindly review and send me your feedback.

Regards,
Bharata.
