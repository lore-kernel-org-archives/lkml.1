Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZFJMJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZFJMJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZFJMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:40 -0400
Received: from mx1.emlix.com ([193.175.82.87]:57804 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>
Subject: imx: serial: add IrDA support to serial driver
Date: Wed, 10 Jun 2009 14:08:27 +0200
Message-Id: <1244635716-23315-1-git-send-email-os@emlix.com>
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

The eighth patch adds IrDA support to the iMX serial driver,
the last one sets the real baud rate thru tty_encode_baud_rate,
as suggested by Alan Cox.
