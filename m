Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbXFCTXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbXFCTXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 15:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbXFCTXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 15:23:44 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:39628 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXFCTXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 15:23:43 -0400
Date: Sun, 3 Jun 2007 00:50:47 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: power@bughost.org
Subject: which is the cause of interrupts
Message-ID: <20070602225047.GL30199@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Jun  1 23:33:08 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
X-Original-Status: RO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Powertop 1.5 tells me:

Wakeups-from-idle per second : 1161.0
no ACPI power usage estimate available

Top causes for wakeups:
  49.3% (898.0)       <interrupt> : ehci_hcd:usb1, uhci_hcd:usb8, wcfxo
  20.1% (366.4)       <interrupt> : ide0
   7.4% (135.0)               bot : schedule_timeout (process_timeout)

Now how can I find which device is triggering those "ehci_hcd:usb1,
uhci_hcd:usb8, wcfxo" interrupts? 


Folkert van Heusden

-- 
MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu überprüfen. Inkl. Filter, Farben, Zusammenführen,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
