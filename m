Return-Path: <linux-kernel-owner+w=401wt.eu-S1750867AbXB0WLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867AbXB0WLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXB0WLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:11:45 -0500
Received: from WWW.CS.ubishops.ca ([206.167.194.132]:48433 "EHLO
	cs.ubishops.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbXB0WLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:11:45 -0500
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 17:11:45 EST
Date: Tue, 27 Feb 2007 16:48:16 -0500
From: Patrick McLean <chutzpah@linuxfreak.ca>
To: linux-kernel@vger.kernel.org
Subject: BUG: at fs/inotify.c:182 set_dentry_child_flags()
Message-ID: <20070227214816.GA3331@odin.ubishops.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have this message in the dmesg on a mail server running on an xfs
filesystem. It appears to have happened at some point when nfsd was
restarted, but I can't seem to convince it to reproduce.

The machine is running Gentoo's 2.6.20 kernel.

BUG: at fs/inotify.c:182 set_dentry_child_flags()

Call Trace:
 [<ffffffff802b7e2a>] set_dentry_child_flags+0xd4/0x132
 [<ffffffff802b7eef>] remove_watch_no_event+0x67/0x76
 [<ffffffff802b7f16>] inotify_remove_watch_locked+0x18/0x3b
 [<ffffffff802b8004>] inotify_rm_wd+0x7e/0xa1
 [<ffffffff802b8519>] sys_inotify_rm_watch+0x46/0x62
 [<ffffffff80253e6e>] system_call+0x7e/0x83

