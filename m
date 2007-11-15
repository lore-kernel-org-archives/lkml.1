Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXKOHLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXKOHLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbXKOGxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:53:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33530 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926AbXKOGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:53:15 -0500
Date: Wed, 14 Nov 2007 22:52:20 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/3] 2.6.23-stable review, filesystem changes
Message-ID: <20071115065220.GA20690@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.X release.
There are 3 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on filesystems.

The diffstat of this review series is included below.

thanks,

greg k-h

-- 

 fs/minix/itree_v1.c |    9 +++++++--
 fs/minix/itree_v2.c |    9 +++++++--
 fs/nfs/write.c      |   17 +++++++++++++----
 fs/ocfs2/aops.c     |   22 ++++++++++++++++++++++
 4 files changed, 49 insertions(+), 8 deletions(-)
