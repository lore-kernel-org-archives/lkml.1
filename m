Return-Path: <linux-kernel-owner+w=401wt.eu-S967815AbXILMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967815AbXILMOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967679AbXILMNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:13:43 -0400
Received: from hyrule.inforealm.org ([62.58.71.23]:45535 "EHLO
	hyrule.inforealm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967669AbXILMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:13:42 -0400
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 08:13:42 EDT
Date: Wed, 12 Sep 2007 14:02:03 +0200
From: Stef Epardaud <stef@epardaud.net>
To: linux-kernel@vger.kernel.org
Subject: Filesystem silent crash with EXT3
Message-ID: <20070912120203.GA23510@inforealm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11+cvs20060403
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am not subscribed to this list, so please CC me on replies.
I have just suffered from a filesystem crash on my laptop. It's an x86
running linux 2.6.22 from Ubutu latest gutsy.
This morning it booted and there were all kinds of strange core dumps.
fsck told me the root filesystem was clean,.
I then did a long test with smartctl which told me my disk was fine.
Then I forced fsck to check the filesystem (I was getting lots of files
not found), which then proceeded to fix plenty of errors, duplicate
missing or shared inodes, and many other errors I did not understand.
After pressing 'y' for about a hunderd times I was pretty convinced I
would not get my data back. Anyways after the 'fix' several parts of my
libc were removed and I cannot boot the system anymore (cannot get a
shell).
I had no idea my EXT3 filesystem could go wrong without notifying me
(fsck thought the filesystem was clean before I forced it). Is this
normal ?
If not, what can I do to figure out what went wrong ?
I am in the process of getting a live linux CD to look at the disk,
maybe there are some logs that can help.
Note that it's the first time I've lost a EXT3 (or EXT2) filesystem
without having experienced any system crash or power failure to explain
the filesystem problem. This machine booted and was turned off properly
for several weeks (at least).
Thanks for any help identifying the problem, I really hope this does not
happen again to me or anyone else.
-- 
Stéphane Epardaud
