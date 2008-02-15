Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbYBOW32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbYBOW32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbYBOW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:28:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945AbYBOW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:28:55 -0500
Date: Fri, 15 Feb 2008 17:28:48 -0500
From: Chris Snook <csnook@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MARKERS depends on MODULES
Message-ID: <20080215222848.GA2440@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Make MARKERS depend on MODULES to prevent build failures with certain configs.

Signed-off-by: Chris Snook <csnook@redhat.com>

diff --git a/init/Kconfig b/init/Kconfig
index dcef8b5..933df15 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -729,6 +729,7 @@ config PROFILING
 
 config MARKERS
 	bool "Activate markers"
+	depends on MODULES
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
