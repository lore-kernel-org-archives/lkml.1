Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbZDIW6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbZDIW6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZDIW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:58:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZDIW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:58:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Fri, 10 Apr 2009 00:57:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904100057.43827.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing two problems with -git from today.

First, resume from hibernation is apparently broken if the storage driver
handling the resume device is modular.  If it is compiled statically into
the kernel, the resume works correctly.  I guess this is a consequence of the
async changes (Arjan, please help).

Second, KDE4 on openSUSE 11.1 sometimes fails to handle audio correctly after
a fresh boot.  Everything seems to work, but there's no sound at all.  It is
sufficient to close the X session and start the desktop environment again to
make it work, though (may that be async too? ;-)).  The hardware in question is
Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller
(rev 02) and the driver is snd_hda_intel.

Thanks,
Rafael
