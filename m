Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYCKCPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYCKCPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYCKCPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:15:34 -0400
Received: from tydraniu.sfires.net ([217.79.144.110]:24844 "EHLO
	tydraniu.sfires.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbYCKCPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:15:33 -0400
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 22:15:33 EDT
Date: Tue, 11 Mar 2008 02:52:47 +0100 (CET)
From: Jan Slupski <jslupski@juljas.net>
To: linux-kernel@vger.kernel.org
cc: flamingice@sourmilk.net, mcgrof@gmail.com
Subject: [patch] Support for 124a:4025 - another version of IOGear GWU513
 802.11g
Message-ID: <Pine.BSO.4.62.0803110242160.28679@tydraniu.sfires.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-131149958-1205200367=:28679"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-131149958-1205200367=:28679
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Hi kernel,

Attached patch (just device id addition) adds support to p54usb driver
for apparently another version of IOGear GWU513 802.11g USB network card
that uses GW3887IK chipset and is recognized as "124a:4025 AirVast" by
lsusb.

Patched 2.6.24.3 Fedora 8 kernel works for me with this card with use of
isl3887usb_bare softmac firmware (second generation - 2.5.8.0, from
http://jbnote.free.fr/prism54usb/PrismFirmwares.html).

Jan Slupski

PS.
Please CC me personally as I'm not on the list. Thanks.

    _  _  _  _  _____________________________________________
    | |_| |\ |  S L U P S K I             jslupski@juljas.net
  |_| | | | \|                             http://juljas.net/
--0-131149958-1205200367=:28679
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=linux-2.6-p54usb-gwu513.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.BSO.4.62.0803110252470.28679@tydraniu.sfires.net>
Content-Description: 
Content-Disposition: attachment; filename=linux-2.6-p54usb-gwu513.patch

ZGlmZiAtcnUgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9wNTR1c2IuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3A1NHVzYi5jDQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9wNTR1c2IuYwkyMDA4LTAzLTExIDAwOjA4OjUwLjAwMDAw
MDAwMCArMDEwMA0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcDU0dXNi
LmMJMjAwOC0wMy0xMSAwMDowODo0Mi4wMDAwMDAwMDAgKzAxMDANCkBAIC02
Myw2ICs2Myw3IEBADQogCXtVU0JfREVWSUNFKDB4MGNkZSwgMHgwMDA4KX0s
CS8qIFNhZ2VtIFhHNzAzQSAqLw0KIAl7VVNCX0RFVklDRSgweDBkOGUsIDB4
Mzc2Mil9LAkvKiBETGluayBEV0wtRzEyMCBDb2hpYmEgKi8NCiAJe1VTQl9E
RVZJQ0UoMHgwOWFhLCAweDEwMDApfSwJLyogU3Bpbm5ha2VyIFByb3RvIGJv
YXJkICovDQorCXtVU0JfREVWSUNFKDB4MTI0YSwgMHg0MDI1KX0sCS8qIElP
R2VhciBHV1U1MTMgKEdXMzg4N0lLIGNoaXApICovDQogCXtVU0JfREVWSUNF
KDB4MTNiMSwgMHgwMDBhKX0sCS8qIExpbmtzeXMgV1VTQjU0RyB2ZXIgMiAq
Lw0KIAl7VVNCX0RFVklDRSgweDEzQjEsIDB4MDAwQyl9LAkvKiBMaW5rc3lz
IFdVU0I1NEFHICovDQogCXtVU0JfREVWSUNFKDB4MTQzNSwgMHgwNDI3KX0s
CS8qIEludmVudGVsIFVSMDU0RyAqLw0K

--0-131149958-1205200367=:28679--
