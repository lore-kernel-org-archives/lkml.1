Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbZLQCSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbZLQCSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbZLQCR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:17:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43762 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbZLQCR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:17:56 -0500
Date: Thu, 17 Dec 2009 13:17:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [resend][GIT PULL] kbuild updates for 2.6.33
Message-Id: <20091217131753.c09c941e.sfr@canb.auug.org.au>
In-Reply-To: <20091216222816.GA8397@sepie.suse.cz>
References: <20091216222816.GA8397@sepie.suse.cz>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Michal,

On Wed, 16 Dec 2009 23:28:16 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
>       kbuild: move autoconf.h to include/generated

Since Rusty's module changes are now upstream, the above change requires
this fixup which I have been carrying in linux-next for some time:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 18:33:17 +1100
Subject: [PATCH] modpost: autoconf.h has moved to include/generated

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f6be2e9..769ea95 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -15,7 +15,7 @@
 #include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
-#include "../../include/linux/autoconf.h"
+#include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
 
 /* Some toolchains use a `_' prefix for all user symbols. */
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
