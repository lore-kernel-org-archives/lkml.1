Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYAPRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYAPRJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYAPRIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:08:49 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:38715 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYAPRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:08:48 -0500
Message-Id: <20080116170541.511233227@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Jan 2008 10:05:41 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/2] serial: explicitly request ttyS0-3 for COM1-4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 8250_pnp discovers COM ports, we only get the correct ttyS names
by accident -- we rely on serial8250_isa_init_ports(), which discovers
the COM ports earlier using the addresses in SERIAL_PORT_DFNS.

These two patches remove the dependency on SERIAL_PORT_DFNS by
explicitly requesting the desired ttyS names.

-- 
