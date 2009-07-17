Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZGQUlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZGQUlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZGQUlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:41:02 -0400
Received: from kroah.org ([198.145.64.141]:50657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZGQUk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:40:58 -0400
Date: Fri, 17 Jul 2009 13:39:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/8] 2.6.27.27-stable review
Message-ID: <20090717203935.GA5641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.27 release.
There are 8 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday July 19, 20:00:00 UTC UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.27-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                      |    7 ++-
 drivers/block/floppy.c        |    5 ++-
 drivers/net/tulip/interrupt.c |   84 +++++++++++++++++++++++++++--------------
 drivers/net/tulip/tulip.h     |   32 +++++++++++++++-
 drivers/pci/iova.c            |   26 +++++++++++--
 include/linux/mm.h            |    2 -
 include/linux/personality.h   |    5 ++-
 include/linux/security.h      |    2 +
 kernel/resource.c             |    2 +-
 kernel/sysctl.c               |    2 -
 mm/Kconfig                    |   18 +++++++++
 mm/mmap.c                     |    3 +
 security/Kconfig              |   22 +----------
 security/security.c           |    3 -
 14 files changed, 145 insertions(+), 68 deletions(-)
