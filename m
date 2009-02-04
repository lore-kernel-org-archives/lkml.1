Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbZBDUvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbZBDUvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZBDUu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:50:57 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52692 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbZBDUu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:50:56 -0500
Date: Wed, 4 Feb 2009 15:50:40 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 2/7] x86: Add an option to compile with -ffunction-sections
 -fdata-sections
In-Reply-To: <200902042128.59009.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902041549470.32142@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <200902041908.42173.rusty@rustcorp.com.au> <alpine.DEB.2.00.0902040453590.32142@vinegar-pot.mit.edu> <200902042128.59009.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:
> Ah, OK, this explanation should probably be in a paragraph in the Kconfig
> help message, rather than hiding on lkml.

Sure.

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c6a2674..3412706 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -602,6 +602,11 @@ config FUNCTION_DATA_SECTIONS
 	  If you say Y here the compiler will give each function
 	  and data structure its own ELF section.

+	  This option conflicts with CONFIG_FUNCTION_TRACER, which
+	  enables profiling code generation, because current GCC does
+	  not support compiling with -ffunction-sections -pg (see
+	  <http://gcc.gnu.org/ml/gcc-help/2008-11/msg00128.html>).
+
 	  If unsure, say N.

 config BOOT_PRINTK_DELAY
