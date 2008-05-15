Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYEOTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYEOTwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbYEOTvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57965 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762068AbYEOTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:22 -0400
Message-Id: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:19 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/9] file locking fixes + fuse nfs export support (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following issues have been fixed since the last post:

  - the lockd fix was incorrect for non-sleeping locks
  - synchronize file handle type numbers with XFS

Thanks to Bruce and Christoph for the reviews.

Patches 1-4 are file locking API changes required for the rest of the
patches.

Patches 5-9 add nfs exporting support for fuse filesystems.

This is for 2.6.27.

Thanks,
Miklos

--
