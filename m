Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZLIJeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZLIJeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZLIJen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:34:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:44105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZLIJem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:34:42 -0500
Date: Wed, 9 Dec 2009 10:33:49 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] kbuild updates for 2.6.33
Message-ID: <20091209093349.GA11837@sepie.suse.cz>
References: <20091208133004.GA22750@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208133004.GA22750@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 02:30:04PM +0100, Michal Marek wrote:
> Hi Linus,
> 
> these are the kbuild patches I collected for 2.6.33. There might be a few
> more later, but this is the main part.
> 
> Thanks,
> Michal
> 
> The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
>   Linus Torvalds (1):
>         Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://repo.or.cz/linux-kbuild.git for-next

Hi Linus,

The kbuild tree now breaks with 250cce26 ("iwlwifi: driver version
track kernel version") which you merged yesterday. Stephen Rothwell
kindly provided a fix, which I would normally apply to the kbuild tree,
but I don't want to rebase it as I already sent the pull request. Could
you please apply the following one-liner when merging the kbuild tree?
Thanks!

Michal


From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Dec 2009 19:56:42 +1100
Subject: [PATCH] net: fix for utsrelease.h moving to generated

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 675b7df..27ca859 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,7 +63,7 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 
 /************************
  * forward declarations *
