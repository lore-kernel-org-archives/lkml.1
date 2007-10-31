Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbXJaOWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbXJaOWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXJaOWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:22:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbXJaOWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:22:15 -0400
Date: Wed, 31 Oct 2007 10:22:12 -0400
From: Dave Jones <davej@redhat.com>
To: Domen Puncer <domen.puncer@telargo.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: FEC_MPC52xx_MDIO oddness.
Message-ID: <20071031142212.GA792@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Domen Puncer <domen.puncer@telargo.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig for this reads..

+config FEC_MPC52xx_MDIO
+       bool "MPC52xx FEC MDIO bus driver"
+       depends on FEC_MPC52xx
+       default y
+       ---help---
+         The MPC5200's FEC can connect to the Ethernet either with
+         an external MII PHY chip or 10 Mbps 7-wire interface
+         (Motorola? industry standard).
+         If your board uses an external PHY connected to FEC, enable this.
+         If not sure, enable.
+         If compiled as module, it will be called 'fec_mpc52xx_phy.ko'.

Because this is bool, it'll never be compiled as a module.
Given that fec_mpc52xx_phy.c has a MODULE_LICENSE()
Should this be a tristate perhaps ?

	Dave

-- 
http://www.codemonkey.org.uk
