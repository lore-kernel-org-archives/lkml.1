Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZBJOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZBJOGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZBJOGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:06:10 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39663 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZBJOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:06:09 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Date: Tue, 10 Feb 2009 15:05:51 +0100
Message-Id: <1234274752-29847-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS core (Version 2): the PPS Linux implementation.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PPS core support into Linux.

Currently I just propose the "core" so after inclusion we can add all
other related stuff as suggested by several people in this list. :)

PPS means "pulse per second" and its API is specified by RFC 2783
(Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).

The code has been tested with the NTPD program
(http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
antennae.


Changelog
=========

Version 1 -> 2
--------------

* fix race during PPS source registration.

* PPS_CHECK removed.

* not needed check in pps_exit() removed.

* Printing stuff on exit removed.

Version [full patchset] -> 1
----------------------------

* stupid filenames removed.

* kernel-doc documentation of exported symbols.

* old BKL-locked ioctl removed.

* !uarg checks in the ioctls removed.

* pps.h revisited but not splitted, since several stuff are shared between
  kernel and user land (I hope this will not stop inclusion...)

Rodolfo


