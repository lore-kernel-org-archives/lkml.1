Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbZBMBeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbZBMBeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZBMBdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:33:49 -0500
Received: from kroah.org ([198.145.64.141]:58459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754932AbZBMBds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:33:48 -0500
Date: Thu, 12 Feb 2009 17:31:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.17
Message-ID: <20090213013157.GA14377@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the announcement of the 2.6.27.17 kernel.

It reverts one patch in the 2.6.27.16 kernel release, which caused an
instant oops if you happened to have a laptop with a docking station.
Many thanks to David Engel for pointing out the problem.

I'll also be replying to this message with a copy of the patch between
2.6.27.16 and 2.6.27.17

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile            |    2 +-
 drivers/acpi/dock.c |    8 +-------
 2 files changed, 2 insertions(+), 8 deletions(-)

Greg Kroah-Hartman (2):
      Revert "ACPI: dock: Don't eval _STA on every show_docked sysfs read"
      Linux 2.6.27.17

