Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYBDRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYBDRGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYBDRFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:05:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35049 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbYBDRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:05:48 -0500
Message-Id: <20080204170409.991123259@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 18:04:10 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [patch 0/3] add perform_write to a_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a_ops->perform_write() was left out from Nick Piggin's new a_ops
patchset, as it was non-essential, and postponed for later inclusion.

This short series reintroduces it, but only adds the fuse
implementation and not simple_perform_write(), which I'm not sure
would be a significant improvement.

This allows larger than 4k buffered writes for fuse, which is one of
the most requested features.

This goes on top of the "fuse: writable mmap" patches.

Thanks,
Miklos

--
