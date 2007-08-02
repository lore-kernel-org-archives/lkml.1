Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbXHBUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbXHBUsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXHBUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:48:45 -0400
Received: from mail.erfurth.eu ([213.131.252.67]:53665 "EHLO mail.erfurth.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbXHBUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:48:44 -0400
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 16:48:44 EDT
Message-ID: <46B23DB0.5010702@perlgolf.de>
Date: Thu, 02 Aug 2007 22:25:20 +0200
From: Nico Erfurth <masta@perlgolf.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070720)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 2.6.22] Adding drivers/usb/misc/iowarrior.c to the Makefile
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Spam_score: -3.9
X-Spam_score_int: -38
X-Spam_bar: ---
X-Spam_report: Spam detection software, running on the system "daemlich.net", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  This patch adds the new iowarrior module to the Makefile in
	drivers/usb. Currently the module isn't build unless another driver from
	usb/misc is selected. Signed-off-by: Nico Erfurth <masta@perlgolf.de> ---
	--- linux/drivers/usb/Makefile.orig 2007-08-02 21:54:16.000000000 +0200 +++
	linux/drivers/usb/Makefile 2007-08-02 22:20:57.000000000 +0200 @@ -38,6 +38,7
	@@ obj-$(CONFIG_USB_EMI26) += misc/ obj-$(CONFIG_USB_EMI62) += misc/ obj-$(CONFIG_USB_FTDI_ELAN)
	+= misc/ obj-$(CONFIG_USB_IDMOUSE) += misc/ +obj-$(CONFIG_USB_IOWARRIOR)
	+= misc/ obj-$(CONFIG_USB_LCD) += misc/ obj-$(CONFIG_USB_LD) += misc/ obj-$(CONFIG_USB_LED)
	+= misc/ [...] 
	Content analysis details:   (-3.9 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.5 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new iowarrior module to the Makefile in drivers/usb.
Currently the module isn't build unless another driver from usb/misc is
selected.

Signed-off-by: Nico Erfurth <masta@perlgolf.de>
---
--- linux/drivers/usb/Makefile.orig     2007-08-02 21:54:16.000000000 +0200
+++ linux/drivers/usb/Makefile  2007-08-02 22:20:57.000000000 +0200
@@ -38,6 +38,7 @@ obj-$(CONFIG_USB_EMI26)               += misc/
 obj-$(CONFIG_USB_EMI62)                += misc/
 obj-$(CONFIG_USB_FTDI_ELAN)    += misc/
 obj-$(CONFIG_USB_IDMOUSE)      += misc/
+obj-$(CONFIG_USB_IOWARRIOR)    += misc/
 obj-$(CONFIG_USB_LCD)          += misc/
 obj-$(CONFIG_USB_LD)           += misc/
 obj-$(CONFIG_USB_LED)          += misc/

