Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXC0TtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXC0TtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXC0TtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:49:12 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:60869 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXC0TtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:49:11 -0400
Date: Tue, 27 Mar 2007 11:49:35 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] Remove duplicate CONFIG_CLOCKEVENTS in ARM kconfig
Message-ID: <20070327184935.GA6437@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

Index: linux-2.6.21-rc5/arch/arm/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/arch/arm/Kconfig
+++ linux-2.6.21-rc5/arch/arm/Kconfig
@@ -33,10 +33,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default n
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default n
-
 config MMU
 	bool
 	default y

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
