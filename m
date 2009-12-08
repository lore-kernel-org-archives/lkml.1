Return-Path: <linux-kernel-owner+w=401wt.eu-S936970AbZLHXO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936970AbZLHXO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZLHXOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:14:22 -0500
Received: from kroah.org ([198.145.64.141]:55403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbZLHXOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:14:21 -0500
Date: Tue, 8 Dec 2009 15:14:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.41
Message-ID: <20091208231406.GA14205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.41 kernel.

There was a build error in the 2.6.27.40 kernel in the emc28xx driver.
This release just reverts the problem patch, if you are using .40 just
fine, no need to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 drivers/media/video/em28xx/em28xx-audio.c |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

Greg Kroah-Hartman (2):
      Revert "V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming"
      Linux 2.6.27.41

