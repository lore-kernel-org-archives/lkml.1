Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXFAVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXFAVXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbXFAVXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:23:16 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:53161 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759037AbXFAVXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:23:15 -0400
Message-ID: <46608E3F.4060201@dgreaves.com>
Date: Fri, 01 Jun 2007 22:23:11 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com
Subject: 2.6.22-rc3 hibernate(?) disables skge wol
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not a regression though, it does it in 2.6.21

If I cause the system to save state to disk then whilst off it no longer
responds to g-wol.

bug report:
# wakeonlan cu
Sending magic packet to 255.255.255.255:9 with 00:0C:6E:F6:47:EE

Nothing happens <grin>


cu:~# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pg
        Wake-on: pg
        Current message level: 0x00000037 (55)
        Link detected: yes

What more can I say?

David
