Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYLEP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYLEP6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYLEP6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:58:03 -0500
Received: from bytemail.bytemark.co.uk ([80.68.81.165]:59430 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYLEP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:58:01 -0500
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2008 10:58:01 EST
Message-ID: <493949B0.6000701@bytemark.co.uk>
Date: Fri, 05 Dec 2008 15:33:04 +0000
From: Alex Howells <alex@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_svw breakage
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afternoon Gents (and Ladies),

I'm setting an interesting problem with the sata_svw driver on a fairly
new (in terms of model) blade server from HP, a BL495c.

[    3.462135] PCI: setting IRQ 14 as level-triggered
[    3.462142] sata_svw 0000:01:0e.0: PCI INT A -> Link[ISF0] -> GSI 14
(level,
low) -> IRQ 14
[    3.465367] sata_svw 0000:01:0e.0: PCI INT A disabled
[    3.467302] sata_svw: probe of 0000:01:0e.0 failed with error -16

Having trouble tracking down what 'error -16' might imply, any pointers
for what the root cause may be and how to address it?

Regards,
Alex
