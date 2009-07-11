Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZGKJOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZGKJOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 05:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZGKJOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 05:14:41 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41941 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZGKJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 05:14:40 -0400
Date: Sat, 11 Jul 2009 11:14:27 +0200
To: linux-kernel@vger.kernel.org
Subject: rfkill rework in 2.6.31-rc, hal/dbus access changes?
Message-ID: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please Cc)

I have written a Gnome applet for turning off and on the various
hardware items using the rfkill interface. It was working very well on
up to 2.6.30. With 2.6.31-rc that infrastructure has been changed, and
now no access mode I know of still works.

- formerly writing 0 or 1 to /sys/class/rfkill/rfkillN/state worked, now
  it returns access denied.

- access via Hal/Dbus (what I am doing) stopped working, too

In the Documentation I only see reference to /dev/rfkill, which isn't a
usefull access method because for the applet to work for every user
(based on the permissions of hal) we need hal/dbus access.

Is this intended behaviour? Is there any other documentation but the
very short rfkill.txt in the kernel's Documentation?

Thanks a lot and all the best

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
AFFPUDDLE (n.)
A puddle which is hidden under a pivoted paving stone. You only know
it's there when you step on the paving stone and the puddle shoots up
your leg.
			--- Douglas Adams, The Meaning of Liff
