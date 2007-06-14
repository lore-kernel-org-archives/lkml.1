Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbXFNN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbXFNN2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXFNN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:28:35 -0400
Received: from smtp2.rz.uni-karlsruhe.de ([129.13.185.218]:42827 "EHLO
	smtp2.rz.uni-karlsruhe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXFNN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:28:34 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 09:28:34 EDT
From: Malte Cornils <malte@cornils.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: PCI setup hangs on Asus Notebook (nolapic helps)
Date: Thu, 14 Jun 2007 15:05:27 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141505.27380.malte@cornils.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

my Asus M2N Notebook hangs doing the following on 2.6.22-rc3 (from Ubuntu 
Gutsy Gibbon Tribe-1):

Setting up standard PCI resources

The non-scrollable output on the full screen can be found here:
http://planck.djpig.de/~mcornils/pci-hang.jpg

Booting with nolapic helps, but makes the SATAized IDE controller buggy 
(spontaneous timeouts occuring, which do not happen on OpenBSD or Windows XP 
(shiver)).

I'm using the latest BIOS (A208). Now I know it's buggy as hell and I've 
already complained to Asus, but to no avail.

There have been other reports of the problem on Asus notebooks. I've collected 
some links:

http://bugzilla.kernel.org/show_bug.cgi?id=8278
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/83290
http://bugzilla.kernel.org/show_bug.cgi?id=7906 (maybe related)
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/8012 (maybe 
related)
http://lists.debian.org/debian-user-german/2006/12/msg01017.html (german)

I'm willing to provide any needed information (like DSDT table, system 
info, ...) and try out almost anything (I do not have a serial console handy 
though - the system does not have serial). 

Yours,
-Malte

PS: A Cc: is preferred, but not necessary.
