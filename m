Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYF0JXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYF0JXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYF0JXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:23:41 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58776 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYF0JX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:23:29 -0400
Date: Fri, 27 Jun 2008 11:23:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeffrey.t.kirsher@intel.com
Subject: [PATCH] Enable E1000E in x86-64/i386 defconfig
Message-ID: <20080627092327.GA17201@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Jun 2008 09:16:09.0142 (UTC) FILETIME=[6F8D3D60:01C8D836]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable E1000E in x86-64/i386 defconfig

That one is a little late, but it would be great if it was considered
for .26 final. Thanks.

-Andi

----

Hit me a few times now: the x86 defconfigs should really enable E1000E,
otherwise kernel build on defconfig don't work anymore if the test box
has a new enough E1000. Previously that worked because e1000 supported
these devices too.

I think enabling it by default gives a smoother transition. Auke
used to have a patch for this too, but it seems to be still not there
in rc8.

BTW it would be probably good to rerun make oldconfig on the x86 defconfigs
at some point. They seem to be a little outdated and generate a huge
diff against a updated oldconfig.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: jeffrey.t.kirsher@intel.com

Index: linux/arch/x86/configs/i386_defconfig
===================================================================
--- linux.orig/arch/x86/configs/i386_defconfig
+++ linux/arch/x86/configs/i386_defconfig
@@ -814,6 +814,8 @@ CONFIG_NETDEV_1000=y
 CONFIG_E1000=y
 # CONFIG_E1000_NAPI is not set
 # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
+CONFIG_E1000E=y
+CONFIG_E1000E_ENABLED=y
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
Index: linux/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux.orig/arch/x86/configs/x86_64_defconfig
+++ linux/arch/x86/configs/x86_64_defconfig
@@ -738,6 +738,8 @@ CONFIG_NETDEV_1000=y
 # CONFIG_ACENIC is not set
 # CONFIG_DL2K is not set
 CONFIG_E1000=y
+CONFIG_E1000E=y
+CONFIG_E1000E_ENABLED=y
 # CONFIG_E1000_NAPI is not set
 # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
 # CONFIG_NS83820 is not set
