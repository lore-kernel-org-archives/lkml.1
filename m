Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZGKDQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZGKDQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 23:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZGKDQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 23:16:14 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:56631 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbZGKDQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 23:16:13 -0400
X-Greylist: delayed 2172 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 23:16:13 EDT
Message-ID: <4A57FB7F.1020702@blueyonder.co.uk>
Date: Sat, 11 Jul 2009 03:39:59 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memcontrol.c: Fix build error 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- memcontrol.c_orig   2009-07-11 03:35:04.040153659 +0100
+++ memcontrol.c        2009-07-11 03:34:08.291161442 +0100
@@ -25,6 +25,7 @@
  #include <linux/smp.h>
  #include <linux/page-flags.h>
  #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
  #include <linux/bit_spinlock.h>
  #include <linux/rcupdate.h>
  #include <linux/limits.h>

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

