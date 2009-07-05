Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZGEAqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZGEAqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 20:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZGEAqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 20:46:14 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37627 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZGEAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 20:46:13 -0400
Date: Sat, 4 Jul 2009 20:44:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] SOUND: Remove commented out usage of dead MODULE_PARM().
Message-ID: <alpine.LFD.2.00.0907042040540.10980@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  get rid of that commented usage of the now defunct MODULE_PARM macro
simply because it pollutes a scan for actual references to that dead
macro.

diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 1edab7b..3136c88 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -110,9 +110,6 @@ static void start_adc(struct cs4297a_state *s);
 // rather than 64k as some of the games work more responsively.
 // log base 2( buff sz = 32k).

-//static unsigned long defaultorder = 3;
-//MODULE_PARM(defaultorder, "i");
-
 //
 // Turn on/off debugging compilation by commenting out "#define CSDEBUG"
 //
========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
