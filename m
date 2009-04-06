Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZDFWsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZDFWsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZDFWr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:47:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZDFWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:47:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [2 regressions] Current git cannot find root device on x86-64 (HP nx6325), NFS broken
Date: Tue, 7 Apr 2009 00:47:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904070047.56172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current mainline (commit 22ae77bc7ac115b9d518d5cbc13d39317079b2b0) can't
find the root device (it's handled by statically compiled-in sata_sil) and
generally causes the "invalid module format" message to appear for all modules
loaded from the initrd on my HP nx6325 (the distro is openSUSE 11.1).

I don't know which commit might have made this happen, but the breakage was
introduced during the last three days (commit
601cc11d054ae4b5e9b5babec3d8e4667a2cb9b5 is certainly good).  I'll bisect
tomorrow if there are no ideas.

Also, mounting directories over NFS doesn't work (I think it oopses, but
didn't have the time to look at it more closely).

Thanks,
Rafael
