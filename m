Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbXBJRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbXBJRxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXBJRxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:53:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:51910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXBJRxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:53:48 -0500
Date: Sat, 10 Feb 2007 17:53:47 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Linux 2.4.35-pre1
Message-ID: <20070210175347.GA13971@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all !

Here comes 2.4.35-pre1. It contains the same fixes as 2.4.34.1, and
provides an update for the e1000 driver as well as a backport of
Stephen Hemminger's skge/sky2 driver which is being used in 2.6.

People concerned by the lack of support for recent chips in current
stable e1000 driver are asked to test this version and complain
loudly if they suspect any regression. I have personally tried it
with success on x86-SMP and Alpha. Note that you need it if you
recently bought some replacement NICs because the old driver is
unlikely to support them anymore.

People equiped with a Marvell gigabit chip may be interested in
giving a try to the current backport of the skge/sky2 driver. The
skge driver seems to work correctly, and better than sk98lin on
UDP. The sky2 driver is still a bit young and I could make it
hang several times under high loads or dirty traffic. That said,
in a testing tree I quickly backported a handful of more recent
patches to it which made it rock solid, so it's just a matter of
work and time. Stephen offered to update it to reflect the version
running in 2.6. As he did a great job till there, I'm sure that
the problems with current sk98lin will soon become bad old
memories.

I delayed the integration of a bunch of harmless typo fixes so
that we can focus on those changes first, so please test this
version !

Thanks in advance,
Willy


Summary of changes from v2.4.34 to v2.4.35-pre1
============================================

Christian Praehauser (1):
      [NET] ethernet: Fix first packet goes out with MAC 00:00:00:00:00:00

dann frazier (1):
      smbfs: fix problems introduced by last security backport

Jesse Brandeburg (3):
      e1000: integrate latest 2.4 linux driver
      [MAINTAINERS]: update e1000 maintainers
      e1000: update README

Oliver Neukum (1):
      proper locking on disconnect for mdc800

Willy Tarreau (2):
      merge 2.6 backport of skge/sky2 network drivers
      Change VERSION to 2.4.35-pre1

