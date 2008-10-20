Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYJTW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYJTW3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYJTW21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:28:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3716 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYJTW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:28:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 0/3] Add file patterns to MAINTAINERS and script to parse MAINTAINERS
Date: Mon, 20 Oct 2008 15:28:21 -0700
Message-Id: <1224541704-30357-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that "F:" is documented in MAINTAINERS, this patchset
adds more patterns and a script to find the maintainer
of an individual file or files in a patch.

Other relevant information from MAINTAINERS sections can
also be generated.

patch 1: Add patterns to MAINTAINERS
patch 2: Add scripts/get_maintainer.pl
patch 3: Miscellaneous cleanups of MAINTAINERS

$ ./scripts/get_maintainer.pl 
usage: ./scripts/get_maintainer.pl [options] patchfile 
       ./scripts/get_maintainer.pl [options] -f file
version: 0.12

MAINTAINER field selection options:
  --email => print email address(es) if any
    --git => include recent git *-by: signers
    --git-chief-penguins => include (Linus Torvalds|Andrew Morton)
    --m => include maintainer(s) if any
    --n => include name 'Full Name <addr@domain.tld>'
    --l => include list(s) if any
    --s => include subscriber only list(s) if any
  --scm => print SCM tree(s) if any
  --status => print status if any
  --subsystem => print subsystem name if any
  --web => print website(s) if any

Output type options:
  --separator [, ] => separator for multiple entries on 1 line
  --multiline => print 1 entry per line

Default options:
  [--email --git --m --l --multiline]

Signed-off-by: Joe Perches <joe@perches.com>


