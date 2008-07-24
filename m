Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYGXKtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYGXKtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYGXKtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:49:39 -0400
Received: from smtp191.iad.emailsrvr.com ([207.97.245.191]:34840 "EHLO
	smtp191.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYGXKti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:49:38 -0400
X-Greylist: delayed 951 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 06:49:38 EDT
Date: Thu, 24 Jul 2008 06:33:47 -0400 (EDT)
Subject: Recommendation on an eSATA card well supported by Linux with built-in drivers and that supports hot plug
From: "Filipe Brandenburger" <filipe.brandenburger@idilia.com>
To: linux-kernel@vger.kernel.org
Reply-To: filipe.brandenburger@idilia.com
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
Message-ID: <56639.192.168.1.35.1216895627.webmail@192.168.1.35>
X-Mailer: webmail6.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, thank you very much for your work on the Linux kernel, I've been using it for the last 10 years and it is really awesome!

Sorry if this is not the appropriate forum for this question, but as Linux drivers end up being discussed here and I know many of you may be using a lot of different hardware, I though I could get some valuable information here. If it's not appropriate (or there would be a better place to ask this question), please let me know about it.

I'm looking for a good eSATA card that is supported by Linux, preferrently using built-in drivers (no need to compile the modules from the vendor), or at least that the vendor's drivers are packaged with dkms or something similar that makes it easy on kernel upgrades.

It's essential that the card supports hot-plugging, because we want to use it to plug backup drives and have them rotated. We are testing an eSATA drive from LaCie (if you have other recommendations on other vendors for eSATA external drives which have >2TB drives, I would appreciate them as well).

I tested the Adaptec eSATA II RAID 1225SA, but just to get the module to compile right it was a huge PITA, and I still didn't get it to recognize our LaCie drive (still not sure why). Instead of spending more time making that crap work, I would rather buy a different card, but then I would try to get one that works well with Linux out-of-the-box.

I looked at feature support of drivers, and it seems to me that the "ahci" driver seems to be the most complete of them, also being a standard interface. It supports the ICH6 chip from Intel and several others, however googling for it I couldn't find any eSATA card that would have this chip or use this driver. Do you know any eSATA card that uses the "ahci" driver? Will it support hot-plugging well?

Other than the "ahci" driver, it seems to me that the "sata_sil24" driver seems to be the next best thing, with support for hot-plugging, etc. The card I have apparently does use it, but its PCI device id is 0244 which is not recognized by the driver as it is (apparently if the driver is patched to include this id it works with the card.) Is there a way to "force" the driver to recognize this PCI id other than recompiling it? And, is this driver really that good and does it support hot-plugging? Could someone recommend another card that would be supported out-of-the-box by this driver?

I don't need RAID support on the card, it really does not matter to me as I won't be using it.

Any advice and recommendations will be much appreciated.

Thank you very much!

Filipe

(Please CC me on your answer if at all possible.)


