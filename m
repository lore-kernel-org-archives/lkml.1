Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXCYR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXCYR2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXCYR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:28:55 -0400
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:31397 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751958AbXCYR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:28:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Jp2xOtdwb7q2L351bjKOtCCmOq+yN66s/ZvdLKyyyeBeTIWIenWwtXZvC3upE5SMChYkQ4pDV92hNykEwKFYeYiQYQQxaF7h0ebBjB8SzSJ5AGqLgoZ5gcZreX3O93fXPQpkAq9yFoVdW73urzhF1VjoKMqj8xce9JNoMJ78I/c=  ;
Message-ID: <20070325172853.30610.qmail@web52910.mail.re2.yahoo.com>
X-YMail-OSG: .xRwGLIVM1m_nngk5UDxMGcTkcqX7n67b0qA6bMI3n4d5U61WiBVIuBkn6VkBRbIkJsm9RhSdihoG4Rlt1hSVY6QYDVjNP1K4SpYMkl1h8SljrwCfRVXDfRxxp0xAqkK74WyIThRrEKn8Re7BWswztpyIg--
Date: Sun, 25 Mar 2007 18:28:53 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: RE: Linux 2.6.20.4
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Linux version 2.6.20.4 (chris@hypercube.homenet) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51))
#1 PREEMPT Sun Mar 25 17:31:32 BST 2007]

Hi,

I have just booted the 2.6.20.4 kernel on an old 350 MHz P2, and am now seeing these messages in
my boot log:

Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)

(It's the "cannot adjust BAR... (not I/O)" that I'm worrying about.)

Are these messages harmless, or should I be concerned? They did not appear in the 2.6.20.3 boot
log.

Here is what lspci has to say about this machine's PCI bus:

$ /sbin/lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03)
00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:0e.0 USB Controller: NEC Corporation USB (rev 41)
00:0e.1 USB Controller: NEC Corporation USB (rev 41)
00:0e.2 USB Controller: NEC Corporation USB 2.0 (rev 02)
00:0f.0 Multimedia audio controller: Ensoniq ES1370 [AudioPCI]
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]

Cheers,
Chris



		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
