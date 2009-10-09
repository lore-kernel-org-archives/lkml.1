Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbZJIX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbZJIX1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934606AbZJIX1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:27:31 -0400
Received: from kroah.org ([198.145.64.141]:56340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934596AbZJIX1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:27:25 -0400
Date: Fri, 9 Oct 2009 16:23:00 -0700
From: Greg KH <gregkh@suse.de>, gregkh@mini.kroah.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/8] 2.6.27.37-stable review
Message-ID: <20091009232300.GA403@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.37 release.
There are 8 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday October 11, 23:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.37-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                   |    2 +-
 arch/x86/ia32/ia32entry.S  |   56 +++++++++++++++++++++++--------------------
 arch/x86/kvm/x86.c         |    6 ++++
 arch/x86/mm/mmap.c         |   17 +++++++++++-
 drivers/net/iseries_veth.c |    2 +-
 drivers/watchdog/hpwdt.c   |   15 +++++------
 fs/ecryptfs/inode.c        |    2 +
 include/asm-x86/elf.h      |    2 +
 include/linux/kvm_para.h   |    1 +
 kernel/time/timekeeping.c  |   22 +++++++++++++++++
 10 files changed, 87 insertions(+), 38 deletions(-)
