Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbXHVJJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbXHVJJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbXHVIxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:48 -0400
Received: from 1wt.eu ([62.212.114.60]:2164 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785AbXHVIxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:45 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084015.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:11 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Gustavo de Nardin <gustavodn@mandriva.com.br>,
       David Woodhouse <dwmw2@infradead.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 27/58] Include serial_reg.h with userspace headers
Content-Disposition: inline; filename=0027-Include-serial_reg.h-with-userspace-headers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to
compile xosview (http://xosview.sourceforge.net/) with upstream kernel
headers being used you get the following errors:
serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
serialmeter.cc: In member function 'virtual void
SerialMeter::checkResources()':
serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
..

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Gustavo de Nardin <gustavodn@mandriva.com.br>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 157db77..199fd71 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -134,6 +134,7 @@ header-y += radeonfb.h
 header-y += raw.h
 header-y += resource.h
 header-y += rose.h
+header-y += serial_reg.h
 header-y += smbno.h
 header-y += snmp.h
 header-y += sockios.h
-- 
1.5.2.5

-- 
