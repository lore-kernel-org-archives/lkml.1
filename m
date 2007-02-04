Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXBDJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXBDJIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 04:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXBDJIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 04:08:21 -0500
Received: from linux.dunaweb.hu ([62.77.196.1]:43815 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXBDJIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:19 -0500
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Feb 2007 04:08:19 EST
Message-ID: <45C59D65.1050706@dunaweb.hu>
Date: Sun, 04 Feb 2007 09:46:29 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       For users of Fedora Core releases 
	<fedora-list@redhat.com>
Subject: How mature is forcedeth?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I replaced my "aging" (means: no SVM) first generation
Athlon64 3200+ and mainboard with a new AM2 X2 4200+
and ABit KN9 SLI which has dual GbE. Both channels are
claimed by forcedeth. I have another machine that is used
mostly as a thin client, it's connected to the main machine
with a crossover cable. The problem is that if I use the
forcedeth ports on the main machine, the thin client doesn't
work correctly. Sometimes it fails to get the IP via DHCP.
Sometimes it doesn't finish booting, either during the TFTP
or NFS mount/transaction. Sometimes it boots up but
X "locks up", e.g. during a window dragging, the window
gets stuck and the pointer doesn't change back to the
regular arrow. With the previous mainboard that used
the r8169 driver everything was OK. I put an 3com card
into the new machine and the thin client works again
via that connection. The system is a fully uptodate FC6,
kernel 2.6.19-1.2895.fc6.

Best regards,
Zoltán Böszörményip
