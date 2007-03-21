Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXCUVcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXCUVcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXCUVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:32:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:40091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXCUVcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:32:47 -0400
From: Andreas Schwab <schwab@suse.de>
To: <rol@as2917.net>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
References: <04ea01c76bed$11b0d050$4b00a8c0@donald>
X-Yow: While you're chewing, think of STEVEN SPIELBERG'S
 bank account..  This will have the same effect as
 two ``STARCH BLOCKERS''!
Date: Wed, 21 Mar 2007 22:32:45 +0100
In-Reply-To: <04ea01c76bed$11b0d050$4b00a8c0@donald> (Paul Rolland's message
	of "Wed, 21 Mar 2007 20:13:50 +0100")
Message-ID: <jeslbyp9j6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Rolland" <rol@as2917.net> writes:

> and df -a reports :
> [root@host-181 src]# df -a
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/hda1              7936256   3105556   4421048  42% /
> proc                         0         0         0   -  /proc
> sysfs                        0         0         0   -  /sys
> devpts                       0         0         0   -  /dev/pts
> tmpfs                   517632         0    517632   0% /dev/shm
> /dev/hda5             61787140    237360  58360480   1% /usr/local/witbe
> /dev/hda2              4956316    142292   4558192   4% /var/log
> none                         0         0         0   -
> /proc/sys/fs/binfmt_misc
>
> So, obviously, /dev is on /, but the stat(2) says no.
> Who is right, and where is the bug ?

Try cat /proc/mounts, apparently when /dev was mounted /etc/mtab wasn't
updated appropriately.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
