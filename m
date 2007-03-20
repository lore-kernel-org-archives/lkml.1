Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbXCTXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbXCTXLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXCTXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:11:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49941 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbXCTXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:11:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <460069F2.5020103@s5r6.in-berlin.de>
Date: Wed, 21 Mar 2007 00:10:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8gsb?= =?ISO-8859-1?Q?erg?= 
	<krh@redhat.com>
Subject: FireWire update in -mm (was 2.6.21-rc4-mm1)
References: <20070319205623.299d0378.akpm@linux-foundation.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
...
>  git-ieee1394.patch
...

Just a note for readers of lkml:  git-ieee1394.patch is steadily growing
thanks to Kristian Høgsberg's work on his new alternative FireWire
drivers.  Recently Kristian posted preliminary patches to the popular
low-level FireWire libraries libraw1394 and libdc1394, making them
interoperable with his newly designed kernel--userspace ABI.  (Mainline
Linux' IEEE 1394 subsystem features a slightly unfortunate variety of
userspace ABIs, some of them abstracted by the mentioned libraries, some
directly used.)  I heard Kristian also already worked on integration
with HAL, i.e. there are now more and more pieces of the puzzle coming
together.
-- 
Stefan Richter
-=====-=-=== --== =-=--
http://arcgraph.de/sr/
