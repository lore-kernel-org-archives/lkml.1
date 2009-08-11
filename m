Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZHKQ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZHKQ24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZHKQ2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:28:55 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56002 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZHKQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:28:54 -0400
Message-Id: <20090811162614.757030930@hardeman.nu>
User-Agent: quilt/0.46-1
Date: Tue, 11 Aug 2009 18:26:14 +0200
From: =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, akpm@linux-foundation.org, bjorn.helgaas@hp.com,
       linux-input@vger.kernel.org
Subject: [patch 0/2] Winbond IR Driver - v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new patch set which should replace all the patches currently in the
-mm tree for the winbond cir driver. The new series incorporate feedback from
Bjorn Helgaas (convert the driver from ACPI to PNP) and Randy Dunlap (Kconfig
fixes).

This set fixes the comments Bjorn Helgaas had on the previous set (wrong Kconfig
depends).

The IR decoding can still be improved but the driver works for in daily use
decoding RC6 commands, so I believe it is ready to go upstream. 

-- 
David Härdeman
