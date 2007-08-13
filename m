Return-Path: <linux-kernel-owner+w=401wt.eu-S1032246AbXHMRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032246AbXHMRJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973411AbXHMQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:48:48 -0400
Received: from chaph.opaya.de ([217.10.9.96]:56844 "EHLO chaph.opaya.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S973405AbXHMQsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:48:45 -0400
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 12:48:45 EDT
Date: Mon, 13 Aug 2007 18:27:42 +0200
From: Steffen Koepf <steffen.koepf@opaya.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] USB-Core, Kernel 2.6.22.2
Message-ID: <20070813162742.GA31804@chaph>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.3.99i
X-Mailer: Mutt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

there is a USB-Device Init-Problem with the Apacer AE161 USB-Cardreader,
which contains the Chip AU6375. The Cardreader init fails in about 50%
of system boots, with the following lines:

usb 1-6: unable to read config index 0 descriptor/all
usb 1-6: can't read configurations, error -71
hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable is bad?

The patch let's the kernel stay in the loop, the cardreader is detected
properly and the loop is never executed more than two times. The second
call of usb_control_msg succeeds always. Maybe it was the developer's 
goal of the loop to fix such things?

cu,

Steffen


--X1bOJ3K7DJ5YkBrT
Content-Type: application/x-gunzip
Content-Disposition: attachment; filename="usb-initfix.diff.gz"
Content-Transfer-Encoding: base64

H4sICEuEwEYCA3VzYi1pbml0Zml4LmRpZmYAlY1BT8JAEIXPu7/iHTHrbstUCxRN6sGjYgh/
oJQpNOA22e2qF/67beECB6LJTGbm5Zv3NnVVQb8XweFQ2/CjyaSGyFC0cfUXOx8Fv47KxnH0
yd4XWzblFWksf9+gpdb6795itQt4CVtgBkoymmbjR1AcT6RS6n/B4q2xg9U4QTzLiLo6WeU5
dJo83KdQ/ZgizyWEEI59OLR4hn79WC5Wi/mglo1tu1werqNUQtQVRmf2CfFdL11Sa8fFvt+O
XTtug7M4PczlL5TN5fZyAQAA

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=README

USB-Cardreader (AU6375) init fix, Steffen Koepf, steffen.koepf@opaya.de

--X1bOJ3K7DJ5YkBrT--
