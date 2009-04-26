Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZDZJT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZDZJT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZDZJSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:18:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39765 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZDZJSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:18:52 -0400
Date: Sun, 26 Apr 2009 11:20:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH] kbuild: fix comment in modpost.c
Message-ID: <20090426092056.GA28058@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org> <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <20090426024221.GA7286@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426024221.GA7286@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this I noticed a bug in a comment in modpost.

	Sam

>From bece3302fa388ee643f8a6bc78463ac20a2f23bb Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 26 Apr 2009 11:17:42 +0200
Subject: [PATCH] kbuild: fix comment in modpost.c

There is some confusion on naming of the head section.
Correct naming is .head.text.

Fix comment so we use correct naming.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c9a01ca..2fdf2bf 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -942,8 +942,7 @@ static int section_mismatch(const char *fromsec, const char *tosec)
  *           *probe_one, *_console, *_timer
  *
  * Pattern 3:
- *   Whitelist all refereces from .text.head to .init.data
- *   Whitelist all refereces from .text.head to .init.text
+ *   Whitelist all refereces from .head.text to any init section
  *
  * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
-- 
1.6.0.2.GIT

