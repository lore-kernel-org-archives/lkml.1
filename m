Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZA2LDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZA2LDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZA2LCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:02:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:54136 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZA2LCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=itsBm+BIY54phjMQSMA6Q+96b6XlEOZ86gtreldhasG69bu2iTpBmhZmfvP9lgYWG+
         3l/DgiXMDgO8hdeSFBYcIjik20dwnUw65HW3q9sASbhyRF1JJRH9mLWGqvpdtkmfDAJR
         QiOwYWwbEpuVtNU4HpOqLsd9tYgUsXDZo0YH4=
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 12:02:49 +0100
Message-ID: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
Subject: NEWBIE: how to change serial device<->port association
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear ML,

how can I instruct the kernel (if possible) to map a certain serial
port to a specific device ttySx?
I have 4 16550 ports and kernel ( the driver, I suppose) say to me:

Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a NS16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS2 at I/O 0x3e8 (irq = 10) is a NS16550A
00:0c: ttyS3 at I/O 0x2e8 (irq = 11) is a NS16550A

I would like to change the map ttySx -> I/O port. I try with setserial
but it doesn't work....Any clue?

TIA

p
