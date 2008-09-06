Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYIFPbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYIFPbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYIFPbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:31:39 -0400
Received: from mail.agmk.net ([91.192.224.71]:9651 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYIFPbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:31:39 -0400
X-Greylist: delayed 2028 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 11:31:38 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: kvm-intel + vista64 installer == BSOD.
Date: Sat, 6 Sep 2008 16:57:41 +0200
User-Agent: PLD Linux KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809061657.41340.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm trying to install vista64 with integrated sp1 on virtual machine
and getting bsod during installer startup ->  http://imagebin.org/25860

hardware: intel q9300 with 8GB of ram.
software: kvm-74, qemu-0.9.1-13k, kernel-2.6.26

in dmesg i found only few lines:

[  277.882001] SIPI to vcpu 1 vector 0x10
[  277.882001] SIPI to vcpu 2 vector 0x10
[  277.882001] SIPI to vcpu 3 vector 0x10
[  283.352002] apic write: bad size=1 fee00030
[  283.352002] Ignoring de-assert INIT to vcpu 0
[  283.352002] Ignoring de-assert INIT to vcpu 1
[  283.352002] Ignoring de-assert INIT to vcpu 2
[  283.352002] Ignoring de-assert INIT to vcpu 3

i have no idea what's wrong :(
