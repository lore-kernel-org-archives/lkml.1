Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZKXANF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZKXANF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZKXANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:13:04 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:45765 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZKXANC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sVbf1ZR5G23U7HJ5fOkwy8nPJAwQTtL5X4vXz9IYO2x+ibOp/+/dVebd0laqq8u+OO
         F64q1d86JI9NQR5yFrDLe810z3Q/HPTVdNSHQZnIJFQWV0ef6znEfsCQALFPGY0L762P
         5jK+76YAPctLxUXSTeXxm+3lAHWivEb5R9A9s=
Subject: The work of ricoh_mmc isn't detected by pci core
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: philipl@alumni.utexas.net
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 02:13:03 +0200
Message-ID: <1259021583.16650.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that usage of ricoh_mmc will lead to this


07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
07:00.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
07:00.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
07:00.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)


I don't have yet an MMC card to test if the driver itself working, 
but what happens is that once disabled, all pci functions shift 
one level, but kernel doesn't pick that up.

If one implements drivers for XD and memstick parts, this would break
everything. (And I have some plans for XD part)

ricoh_mmc is built-in, but this doesn't help.

Best regards,
Maxim Levitsky

