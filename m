Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXBNWCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXBNWCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964795AbXBNWCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:02:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791AbXBNWCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:02:00 -0500
Date: Wed, 14 Feb 2007 16:54:31 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: export of_find_property
Message-ID: <20070214215431.GA21779@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, building drivers/serial/of_serial.c as a module fails.

WARNING: ".of_find_property" [drivers/serial/of_serial.ko] undefined!

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.20.noarch/arch/powerpc/kernel/prom.c~	2007-02-14 16:52:47.000000000 -0500
+++ linux-2.6.20.noarch/arch/powerpc/kernel/prom.c	2007-02-14 16:52:57.000000000 -0500
@@ -1599,6 +1599,7 @@ struct property *of_find_property(const 
 
 	return pp;
 }
+EXPORT_SYMBOL(of_find_property);
 
 /*
  * Find a property with a given name for a given node

-- 
http://www.codemonkey.org.uk
