Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393Ab0ANXLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0ANXLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931Ab0ANXLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:11:13 -0500
Received: from kroah.org ([198.145.64.141]:41935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab0ANXKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:13 -0500
Date: Thu, 14 Jan 2010 15:06:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/6] 2.6.27.44-stable review
Message-ID: <20100114230640.GA7259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.44 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Saturday, January 16, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.44-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                        |    2 +-
 arch/powerpc/kernel/align.c     |   63 ++++++++++++++++++++++++++++----------
 arch/powerpc/kernel/fpu.S       |    5 +++
 arch/powerpc/kernel/misc_64.S   |    8 +++++
 kernel/audit_tree.c             |   13 +++++---
 kernel/signal.c                 |    3 +-
 net/bridge/netfilter/ebtables.c |    6 ++++
 7 files changed, 76 insertions(+), 24 deletions(-)
