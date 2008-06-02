Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYFBNcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYFBNcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYFBNc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:32:29 -0400
Received: from openfortress.nl ([213.189.19.244]:37406 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752373AbYFBNc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:32:28 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 09:32:28 EDT
Date: Mon, 2 Jun 2008 12:59:04 +0000
From: Rick van Rein <rick@groengemak.nl>
To: linux-kernel@vger.kernel.org
Subject: Future Linux on Bistable Storage
Message-ID: <20080602125904.GA15129@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Future generations of Linux are likely to run on machines with non-volatile
memories based on bistable technologies.  This will save the energy of DRAM
refresh cycles and avoid the mechanical problems related to hard disks.  The
result is probably a computer with no distinction between disk and RAM.

Such computer architectures can conserve a lot of energy, as it is very
simple to suspend and resume them: no data loss means no time needed to
resume the system -- except perhaps for I/O initialisation.  Conserving
energy means (1) having more fun|hours per kg of batteries, and (2) saving
the planet.


I wonder inhowfar Linux is (already) capable of dealing with such hardware.
Several core concepts suddenly become meaningless if disk and RAM are merged
into one storage device:
 * swapping out data
 * lazy loading of programs from disk to RAM
 * buffering disk blocks
 * mapping and unmapping disk onto RAM


Regarding I/O init: Current Linux boots while initiating one device at a
time.  Some degree of serialism must exist, but after scanning a bus would
it not be possible to fork threads to initiate each of the devices found
on it?  Am I overlooking details or could this be a useful change?
If it is possible, it would make Linux _much_ quicker to boot (also on
current hardware), and it could even make it acceptable to do a suspend
after a _very_ short time (say, a minute) of non-activity.  It'd be an
easy way to save some trees :)

In the long run, it seems fair to assume that all devices, including
processors, would use non-volatile buffers based on one of the bistable
semiconductor devices currently being developed; but I would not be
surprised if at first we will be working with computers that have older
parts mixed in; boards that still forget their registers when switched off.
But in the end I expect the entire system to switch itself off in between
every two keystrokes (!) simply because loosing no data anywhere in the
system means being able to resume operations at the next whim/interrupt.


I have seen Linux make quite impressive changes to its fundamental
architecture.  Could this be the Next Big Challenge to the flexibility
of our favourite OS?  What would have to change to make it happen, and
is it doable?


Finally, a few background links:

* WikiPedia on Non-volatile memory; especially review the "Upcoming"
  technologies FeRAM, MRAM, NRAM, PRAM, and so on:
  http://en.wikipedia.org/wiki/Non-volatile_memory

* "Towards Zero-power Computing" at GroenGemak:
  http://groengemak.nl/en/article/2008-05-19-10-05.toekomst-computer.html


Yours truly,

Rick van Rein
GroenGemak
http://groengemak.nl/

