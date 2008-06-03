Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYFCWbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYFCWbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYFCWbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:31:41 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:55219 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYFCWbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:31:40 -0400
Date: Tue, 3 Jun 2008 17:31:28 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>, tklein@de.ibm.com,
       themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] ehea: remove dependency on MEMORY_HOTPLUG
Message-ID: <20080603223128.GD7475@localdomain>
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>
 <20080528164405.GA4836@localdomain>
 <200806031007.40162.hannes.hering@linux.vnet.ibm.com>
 <20080603204908.GB7475@localdomain> <1212527335.23656.2.camel@badari-desktop>
 <4845B382.20205@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4845B382.20205@garzik.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: D5129362-31BC-11DD-8771-F9737025C2AA-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that walk_memory_resource() is available regardless of
MEMORY_HOTPLUG's setting, this dependency is not needed.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd0ec9e..f4182cf 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2426,7 +2426,7 @@ config CHELSIO_T3
 
 config EHEA
 	tristate "eHEA Ethernet support"
-	depends on IBMEBUS && INET && SPARSEMEM && MEMORY_HOTPLUG
+	depends on IBMEBUS && INET && SPARSEMEM
 	select INET_LRO
 	---help---
 	  This driver supports the IBM pSeries eHEA ethernet adapter.
-- 
1.5.5

