Return-Path: <linux-kernel-owner+w=401wt.eu-S1423143AbXBBG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423143AbXBBG3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423139AbXBBG3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:29:39 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57375 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423145AbXBBG3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:29:39 -0500
Date: Fri, 2 Feb 2007 07:29:41 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: takada <takada@mbf.nifty.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org
Subject: Please revert "fix typo in geode_configre()@cyrix.c"
Message-ID: <20070202062941.GB3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba

Rationale:

The thread starting with http://lkml.org/lkml/2007/1/9/63 contains 
a discussion about what might be a correct patch.

Somehow the first patch of this discussion made it into 2.6.20-rc, but 
the ones considered more correct are later in the thread.

Since there is AFAIK no actually observed problem fixed by this, it 
should be safe to simply revert the patch for 2.6.20.

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

