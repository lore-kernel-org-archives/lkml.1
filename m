Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZFINrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZFINrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZFINqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:54 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46948 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: imx: serial: add IrDA support to serial driver
Date: Tue,  9 Jun 2009 15:46:43 +0200
Message-Id: <1244555211-15618-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using the iMX serial driver with an IrDA device
needs extra peripheral settings and specific
timing depending on the transmitter circuitry used.

The first five patches fix minor problems in the
generic part of the iMX serial driver

The sixth introduces a generic function to calculate optimum
numerator denominator value pairs for PLL and clock
register settings, the seventh patch uses this function
in the iMX serial driver.

The last patch finally adds IrDA support to the iMX serial driver.
