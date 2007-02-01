Return-Path: <linux-kernel-owner+w=401wt.eu-S1422751AbXBALkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422751AbXBALkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXBALkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:40:11 -0500
Received: from 147.175.241.83.in-addr.dgcsystems.net ([83.241.175.147]:19522
	"EHLO tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422751AbXBALkJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:40:09 -0500
X-Greylist: delayed 817 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 06:40:09 EST
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Organization: Transmode AB
X-Mailer: Evolution 2.8.2.1 
Content-Class: urn:content-classes:message
Subject: ip_auto_config bug in 2.6.20-rc6
Date: Thu, 1 Feb 2007 12:26:27 +0100
Message-ID: <1170329187.15627.11.camel@gentoo-jocke.transmode.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ip_auto_config bug in 2.6.20-rc6
thread-index: AcdF88/9HKrgPJNxRSSNhYsMnrupWw==
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "Netdev" <netdev@vger.kernel.org>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>
Reply-To: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following commandline:
 root=/dev/mtdblock6 rw rootfstype=jffs2 ip=192.168.1.10:::255.255.255.0:localhost.localdomain:eth1:off console=ttyS0,115200
makes ip_auto_config fall back to DHCP and complain "IP-Config: Incomplete network configuration information."
depending on if CONFIG_IP_PNP_DHCP is set or not.

The only way I can make ip_auto_config accept my IP config is to add an entry for the server IP:
ip=192.168.1.10:192.168.1.15::255.255.255.0:localhost.localdomain:eth1:off

I think this is a bug since I am not using a NFS root FS.

 Jocke


