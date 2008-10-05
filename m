Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbYJEQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbYJEQgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbYJEQ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:28:05 -0400
Received: from toomai.ethgen.de ([85.10.201.50]:52446 "EHLO toomai.ethgen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666AbYJEQ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:28:04 -0400
X-Greylist: delayed 2804 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 12:28:03 EDT
Date: Sun, 5 Oct 2008 16:41:16 +0100
From: Klaus Ethgen <Klaus@Ethgen.de>
To: linux-kernel@vger.kernel.org
Subject: Kernel freeze on 2.4.36.7
Message-ID: <20081005154113.GA8387@ikki.ethgen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I use the stable kernel tree 2.4 and have reproduce the following bug
with 2.4.36.2 and 2.4.36.7.

I got a new barcode scanner and plugged it into USB. The scanner works
well until I remove it. In that second I get a trace and the kernel
freeze.

The message when I plug in the scanner:
 hub.c: new USB device 00:1d.7-6.2, assigned address 5
 input: USB HID v1.10 Keyboard [Weltrend Bar Code Reader] on usb1:5.0

The message when I unplug it:
 Unable to handle kernel NULL pointer dereference at virtual address 00000048
 ...

Please pardon that I do not type the complete kernel dump as I know no
way to log it to a text file in this case where the system freeze. But
on request I can send the picture I made with my camera.

Regards
   Klaus Ethgen
- -- 
Klaus Ethgen                            http://www.ethgen.de/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBSOjgGZ+OKpjRpO3lAQL8cwf/ZyfKmgqXqMxIFa3yvTpLoDyUPq+Tmopb
A+sdoqb4F57r00YDsewZulGQ+gFlWHLu7RJENQ7HRtOVIIsW89TSniqVaWhBecKe
y7yZcEv8jCyI+RlGdyY8ZtcTDJSpLh9AY99q48PJLQ9Zxbe5FlOhELaJ1eVYAHHT
NhbeEiVk9BKo7MpsbiQeMr+lb2ePE7x0Ct1J2NBMCMnv9/BrYfPZQXf9ML9bhqgb
ZJC0gM4luJ3OCFP29ygCfyUES9D04KcFoI2S+bSG1nhFSSmYzrNNoDEk3+FO5+E2
e7bD5/nYWoCdRFFAhE08lGrx/cnrSBBZjaOwl1MhZSOCYjMDgLn9UA==
=owdm
-----END PGP SIGNATURE-----
