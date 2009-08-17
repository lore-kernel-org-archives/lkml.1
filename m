Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZHQPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZHQPf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZHQPf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:35:59 -0400
Received: from kroah.org ([198.145.64.141]:35643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZHQPf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:35:58 -0400
Date: Mon, 17 Aug 2009 08:33:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.30
Message-ID: <20090817153358.GA29515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.31 kernel.  It fixes a build
problem of the 2.6.27.30 kernel that shows up on 64bit architectures.
If you are not hitting this problem, there is no need to upgrade to this
kernel release.

I'll also be replying to this message with a copy of the patch between
2.6.27.30 and 2.6.27.31

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile          |    2 +-
 fs/compat_ioctl.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      Revert "compat_ioctl: hook up compat handler for FIEMAP ioctl"
      Linux 2.6.27.31

