Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYJFK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYJFK61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYJFK6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:58:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:46351 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJFK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wPD2F7MugHvrWBF7wZnEA6+925ahJGdLrZxPbOTs8ECrOvYsbK/teOdXDzHyGLKbSy
         XvyjDNlOS9oEpPnPtiImFtV9pUb2/VYREHY8HrZwW+4AkdOUHadZ8jI7/Hy2D2hcHCbV
         wjhethna0GVxM8gP1IKXG21+p2xBmsmk0ip4o=
Message-ID: <bcb3ef430810060358i3439bb06t599a526facabeabb@mail.gmail.com>
Date: Mon, 6 Oct 2008 12:58:17 +0200
From: MartinG <gronslet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: pci 0000:00:1e.0: BAR 7: can't allocate I/O resource [0x10000-0xffff]
Cc: MartinG <gronslet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I get the following error when booting my latest Fedora rawhide
kernel (2.6.27-0.391.rc8.git7.fc10.i686):
pci 0000:00:1e.0: BAR 7: can't allocate I/O resource [0x10000-0xffff]

I'm not sure what it means, or what it implies, as my system seemingly
works just the way it did earlier.
lspci reports:
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
(prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=06, sec-latency=32
        Memory behind bridge: dfc00000-dfcfffff
        Prefetchable memory behind bridge:
0000000060000000-0000000063ffffff
        Capabilities: [50] Subsystem: Dell Device 01a3


This is on a Dell Latitude X1, smolt profile:
http://www.smolts.org/client/show/pub_01507560-2bed-4c14-94a5-c72964bb4b84
Full dmesg output here:
http://pastebin.com/m2174ef7e

Just wanted to report this - I'd be happy to provide more info if needed.

Please cc me on reply
-MartinG
