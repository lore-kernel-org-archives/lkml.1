Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbXBSPBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbXBSPBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbXBSPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:01:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:33766 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbXBSPBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:01:52 -0500
Message-ID: <45D9BBBC.3050302@qumranet.com>
Date: Mon, 19 Feb 2007 17:01:16 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: kvm development moving to git
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kvm kernel code is now developed using git.  This was done for two reasons:
- with the paravirtualization work, we have code in the kernel beyond 
drivers/kvm/.  Subversion is not quite up to hosting an entire kernel 
tree efficiently.
- people have expressed interest in maintaining long-term branches of 
kvm.  This is something that git is quite good at, while with subversion 
this requires an account on our systems.

You can pull from my repository by issuing the command

  git pull git://kvm.qumranet.com/home/avi/kvm/linux-2.6

Please do not clone from this URL.  Instead, clone from git.kernel.org 
so that you clog their pipes instead of mine.  Then issue the pull 
command as described above.

The module source files have been removed from the subversion tree.  To 
compile an external module, first copy the files from a Linux tree:

  make LINUX=/path/to/linux/tree/that/has/pulled/from/the/kvm/repo sync
  make

-- 
error compiling committee.c: too many arguments to function

