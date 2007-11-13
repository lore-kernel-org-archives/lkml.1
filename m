Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbXKMVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbXKMVSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXKMVSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:18:07 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:64833 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbXKMVSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:18:06 -0500
From: Peter Steinmeyer <net@stonechip.de>
To: linux-kernel@vger.kernel.org
Subject: How to do a pci-bus config scan manually?
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1291
Date: Tue, 13 Nov 2007 22:16:30 +0100
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200711132216.30778@walhalla>
X-RZG-AUTH: klqoU1sTRU+9fCFQtMOiwWvHbLLk4UbOPSRkN8f6gvtz6K8JXRTn7lE4
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo!
I'm wondering if I could do a manual pci bus reset from kernel (or userspace)
with kernel 2.6.18.
The background is as follows: We have a self build pci-express card with
FPGA chip mounted on it. The FPGA can be programmend via an additional serial
interface, but the system becomes not aware of the changes made on the card.
On reloading my device driver module I get the same address mapping as before
but if I access the registers the behaviour is undefined.
I think this is because the FPGA disconnects from the pci bus while
programming. So I have to reboot the machine to reinit.
Is there a way to tell the kernel respectively the pci subsystem to do a
pci-bus config scan to recognize the changes without rebooting?
Have a good day, Peter
