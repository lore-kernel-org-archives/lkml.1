Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbYGQXDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbYGQXDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbYGQXDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:03:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbYGQXDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:03:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 17: early crash on x86-64
Date: Fri, 18 Jul 2008 01:06:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20080718012842.690b8346.sfr@canb.auug.org.au>
In-Reply-To: <20080718012842.690b8346.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807180106.08328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080716:
> 
> Temporarily dropped tree: ttydev (it gets too many patch failures).
> 
> Changed trees: the security-testing tree was moved later in the merge in
> anticipation of majo merge problems that have been delayed.
> 	The vfs tree changed branch names.
> 
> Most of the differences were conflicts moving from tree to tree as some
> of the trees are now merged into Linus' tree.  Most have been inflicted
> on the driver-core and usb trees.  I have not notified these separately.
> 
> Because of the moving of conflicts around it is difficult to tell when
> they are going away (though I assume some are).
> 
> The driver-core tree gained two build fixes from the scsi tree (since
> that went into Linus' tree).
> 
> The usb tree gained a conflict from the firmware tree (ditto).
> 
> The x86 tree gained an expected conflict against the stackprotector and a
> build failure that required a revert of a commit.
> 
> The pci tree needed another build fix patch.
> 
> The ide tree had more conflicts with its parts that have been merged into
> Linus' tree.
> 
> The acpi had various merge problems - maybe because I am pulling a
> different tree than what was merged into Linus' tree.
> 
> The galak tree gained a conflict against the net tree.
> 
> The ubifs tree also had merge problems because a different version was
> sent to Linus.
> 
> I have also applied the following patches for known problems:
> 
> 	sparc64: sysdev API change fallout
> 
> This tree fails to build for ARCH=sparc (i.e. 32bit) with a 64bit gcc
> v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
> of one of my merge fixups, but I don't actually think so.

This one crashes all of my x86-64 test boxes early during boot.

The Linus' tree is not affected.

Failing configs:
http://www.sisk.pl/kernel/debug/next/20080717/HPC_nx6325-config
http://www.sisk.pl/kernel/debug/next/20080717/M3A32-MVP-config

It's not very likely that I'll be able to bisect this issue before OLS, so most
probably I won't be testing linux-next in the next several days.

Thanks,
Rafael
