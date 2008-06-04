Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYFDMxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYFDMxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYFDMxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:53:19 -0400
Received: from kumera.dghda.com ([80.68.90.171]:3654 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYFDMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:53:18 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 08:53:18 EDT
From: "Duane Griffin" <duaneg@dghda.com>
To: akpm@linux-foundation.org
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ext{2,3,4}: don't inherit inappropriate inode flags from parent
Date: Wed,  4 Jun 2008 13:46:25 +0100
Message-Id: <1212583588-5754-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866. It also prevents inheritance
of other flags that Andreas Dilger identified as inappropriate to inherit. I'll
follow up shortly with a separate set of patches to prevent flags being set on
inappropriate node types.

Cheers,
Duane.
