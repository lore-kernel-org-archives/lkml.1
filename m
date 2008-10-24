Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJXNjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJXNjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYJXNjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:39:35 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:48513 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJXNjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:39:35 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 09:39:35 EDT
Subject: [PATCH trivial fix] Change UTF8 chars in Kconfig help text about
	Oprofile AMD barcelona
From: Jesper Dangaard Brouer <jdb@comx.dk>
Reply-To: jdb@comx.dk
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: ComX Networks A/S
Date: Fri, 24 Oct 2008 15:05:12 +0200
Message-Id: <1224853512.2019.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes screwing up text output when doing a make oldconfig and viewing
help text of "OProfile AMD IBS support".  When the terminal is
not using an UTF8 locale / LANG.  "make config" breaks terminal output
and its not possible to continue.

(Change added by changeset 852402cc Tue Jul 22 21:09:06 2008)

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 arch/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e6ab550..8977d99 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -21,7 +21,7 @@ config OPROFILE_IBS
           Instruction-Based Sampling (IBS) is a new profiling
           technique that provides rich, precise program performance
           information. IBS is introduced by AMD Family10h processors
-          (AMD Opteron Quad-Core processor “Barcelona”) to overcome
+          (AMD Opteron Quad-Core processor "Barcelona") to overcome
           the limitations of conventional performance counter
           sampling.
 
-- 
1.5.4.2


