Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXGOSwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXGOSwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 14:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGOSwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 14:52:42 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:42981
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751430AbXGOSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 14:52:42 -0400
Date: Sun, 15 Jul 2007 20:54:09 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [0/5] file system core: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715185409.GE4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset replaces some list_for_each() loops by
list_for_each_entry() loops in the following file system functions:

fs_may_remount_ro()
ep_poll_safewake(()
sget()
posix_locks_deadlock()
get_locks_status()
nr_blockdev_pages()

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
