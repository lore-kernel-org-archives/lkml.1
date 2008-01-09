Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYAIRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYAIRlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYAIRlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:41:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYAIRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:41:16 -0500
Date: Wed, 9 Jan 2008 09:44:34 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.13
Message-ID: <20080109174434.GA11284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.13 kernel.
It contains one serious fix for the w83627ehf.c hardware monitoring
driver.  If you use this driver, PLEASE, upgrade to this kernel version.
To quote the developer, Jean Delvare:
	I have had a private report that this bug might have caused
	permanent hardware damage. There is no definitive proof at this
	point, but unfortunately due to the lack of documentation I
	really can't rule it out.
This problem only affects the 2.6.23 kernel releases, it is not present
on any prior release, or on the 2.6.24 upcoming release, as this fix is
already in Linus's tree.

I'll also be replying to this message with a copy of the patch between
2.6.23.12 and 2.6.23.13

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                  |    2 +-
 drivers/hwmon/w83627ehf.c |   36 ++++++++++++++++++++++--------------
 2 files changed, 23 insertions(+), 15 deletions(-)

Summary of changes from v2.6.23.12 to v2.6.23.13
================================================

Greg Kroah-Hartman (1):
      Linux 2.6.23.13

Jean Delvare (1):
      hwmon: (w83627ehf) Be more careful when changing VID input level

