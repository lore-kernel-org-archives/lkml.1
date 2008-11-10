Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbYKJOYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbYKJOYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYKJOYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:24:41 -0500
Received: from ltw.loris.tv ([85.14.220.160]:60028 "EHLO ltw.loris.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYKJOYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:24:40 -0500
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 09:24:39 EST
Date: Mon, 10 Nov 2008 14:58:25 +0100
To: zippel@linux-m68.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       linux-kbuild@vger.kernel.org
Subject: [PATCH 1/1] Kconfig: Correct sched-rt-group.txt pathname in init/Kconfig
Message-ID: <20081110135825.GC2784@ltw.loris.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
From: adi@drcomp.erfurt.thur.de (Adrian Knoth)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Knoth <adi@drcomp.erfurt.thur.de>

init/Kconfig directs the user to Documentation/sched-rt-group.txt, but
the file is actually in Documentation/scheduler/sched-rt-group.txt.

This patch corrects the pathname mentioned in init/Kconfig.

Signed-off-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
---
Present in 2.6.28-rc4, though discovered in 2.6.27.5.

--- init/Kconfig        2008-11-10 14:35:45.000000000 +0100
+++ init/Kconfig.new    2008-11-10 14:37:11.000000000 +0100
@@ -354,7 +354,7 @@
          setting below. If enabled, it will also make it impossible to
          schedule realtime tasks for non-root users until you allocate
          realtime bandwidth for them.
-         See Documentation/sched-rt-group.txt for more information.
+         See Documentation/scheduler/sched-rt-group.txt for more information.
 
 choice
        depends on GROUP_SCHED


-- 
mail: adi@thur.de  	http://adi.thur.de	PGP/GPG: key via keyserver

Ich kann Bedenken nicht mehr hören. Ich will nur noch machen.
					(Lutz Donnerhacke via email)
