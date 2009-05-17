Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZEQRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZEQRLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 13:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZEQRKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 13:10:45 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49829 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZEQRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 13:10:44 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rcX VIA agp initialization
Date: Sun, 17 May 2009 12:10:41 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171210.43999.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been seeing the following in my dmesg:

- - - snip - - - -
agpgart-via 0000:00:00.0: AGP 3.5 bridge
agpgart-via 0000:00:00.0: putting AGP V3 device into 8x mode
pci 0000:01:00.0: putting AGP V3 device into 8x mode
mtrr: no MTRR for a0000000,4000000 found
agpgart-via 0000:00:00.0: AGP 3.5 bridge
agpgart-via 0000:00:00.0: putting AGP V3 device into 8x mode
pci 0000:01:00.0: putting AGP V3 device into 8x mode
- - - - snip - - - -

Is that as intended?  Just cosmetic?

Or is that driver actually being initialized twice?
Notes: 
The driver is "built-in" not a module.
The chip-set is VIA-CX700.
The driver/hardware does appear to survive the experience.  ;)

Mike
