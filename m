Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZI0QMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZI0QMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZI0QMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:12:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbZI0QMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:12:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge commit
Date: Sun, 27 Sep 2009 18:13:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <E1MrRDa-0002WF-LO@closure.thunk.org>
In-Reply-To: <E1MrRDa-0002WF-LO@closure.thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909271813.42829.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 September 2009, Theodore Ts'o wrote:
> Hi,
> 
> One of the things I've been trying to track for the last couple of days
> is a suspend/resume regression which I've noticed on my T400 Lenovo
> laptop.  I first noticed it on a 2.6.31-git9 kernel with a some
> additional ext4 patches.  I've since bisected it to the following merge
> commit: a03fdb76.  The commit does have some merge conflict fix ups, but
> only for the some files in the m68knommu and mips architectures.
> Furthermore, both parent commits (202c467 and 12e0933) work fine.  I've
> tried looking at the global history, and I'm not seeing anything
> obvious.

This commit has been reported to break hibernation for Ondrej:

commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
Author: Magnus Damm <magnus.damm@gmail.com>
Date:   Tue Jul 28 14:09:55 2009 -0700

    clocksource: Save mult_orig in clocksource_disable()

Please try to revert it and retest.

Best,
Rafael
