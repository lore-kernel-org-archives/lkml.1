Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXJMONJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXJMONJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXJMOMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:12:54 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:40992 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754171AbXJMOMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:12:53 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: Bluetooth wireless mouse very sluggish when there is moderated network activity
Date: Sat, 13 Oct 2007 17:13:03 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710131713.03345.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got a Bluetooth wireless mouse identifed as,

input: Microsoft Microsoft� Wireless Notebook Presenter Mouse 8000 
as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/3-1.3:1.0/input/input12
input: USB HID v1.11 Mouse [Microsoft Microsoft� Wireless Notebook Presenter 
Mouse 8000] on usb-0000:00:1d.1-1.3

Problem is when there is a moderate traffic on wireless interface (300-400k/s 
down 50-60k/up on 4Mbit) mouse is really sluggish. This is when I am running 
ktorrent. If I stop the torrent download/upload its fine again.

Any idea how to debug this, or why it might be happening. Btw I confirmed this 
behaviour on

kernel 2.8.18.8, 2.6.22, 2.6.23 and latest GIT tree.

P.S: If it matters I am using ipw3945 driver with 2.6.18 kernel and iwl3945 
with the newer ones.

Regards,
ismail

-- 
Faith is believing what you know isn't so -- Mark Twain
