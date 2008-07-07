Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYGGVXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYGGVXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYGGVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:23:12 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:36677 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbYGGVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:23:11 -0400
X-Greylist: delayed 1758 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 17:23:10 EDT
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:23:09 +0200
User-Agent: KMail/1.9.9
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072308.57529.IvDoorn@gmail.com>
In-Reply-To: <200807072308.57529.IvDoorn@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072323.09177.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 706061e527a23eaab6b0df22823cde1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 23:08:57 you wrote:
> > dmesg 2.6.26-rc9
> > ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> > phy0: Selected rate control algorithm 'pid'
> > phy0: Failed to initialize wep
>
> Check if the arc4 and ecb modules are loaded before loading mac80211 &
> rt2500pci.

They weren't, but loading them before doesn't make any difference.
I've to add that I don't use wep, this WLAN is open.

Regards,
Stefan
