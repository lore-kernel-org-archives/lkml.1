Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935883Ab0CMAwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:52:47 -0500
Received: from kroah.org ([198.145.64.141]:46979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935449Ab0CMAbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:44 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:11 2010
Message-Id: <20100313002711.340432975@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>
Subject: [070/145] oprofile: remove tracing build dependency
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Robert Richter <robert.richter@amd.com>

commit 18b4a4d59e97e7ff13ee84b5bec79f3fc70a9f0a upstream.

The commit

 1155de4 ring-buffer: Make it generally available

already made ring-buffer available without the TRACING option
enabled. This patch removes the TRACING dependency from oprofile.

Fixes also oprofile configuration on ia64.

The patch also applies to the 2.6.32-stable kernel.

Reported-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -6,8 +6,6 @@ config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
-	depends on TRACING_SUPPORT
-	select TRACING
 	select RING_BUFFER
 	select RING_BUFFER_ALLOW_SWAP
 	help


