Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXI0JZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXI0JZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXI0JZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:25:42 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3982 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbXI0JZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:25:41 -0400
Date: Thu, 27 Sep 2007 11:25:21 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Updating include/asm symlink when $ARCH changes
Message-ID: <20070927092521.GA27491@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I cross compile arm and mips kernels from the same kernel tree.  When
I build a kernel the first time with a fresh kernel tree, the
include/asm symlink is set properly.  However, when I compile for a
different $ARCH, the include/asm is not changed and the build fails.

Would it be possible for the build system to update the include/asm
symlink when it doesn't correspond to the architecture you're
currently trying to build for?
-- 
Martin Michlmayr
http://www.cyrius.com/
