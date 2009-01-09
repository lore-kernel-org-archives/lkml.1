Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZAIPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZAIPHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZAIPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:07:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:49915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZAIPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:07:09 -0500
Date: Fri, 9 Jan 2009 07:09:10 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Partially defer some of the async stuff to the next release
Message-ID: <20090109070910.233e5f3c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I think it's better that we defer some of the asynchronous boot stuff to
2.6.30 so that it can bake in -next for a bit. I would like to keep the
core infrastructure in place for 29, so that the various subsystem
patches etc can just use it in -next without generating dependencies in
the patch flow.

for both libata and the inode delete very simple things can be done to
fix them, but I would feel a lot more comfortable giving these a ride
in -next.


The following changes since commit
2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f: Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-undo.git
  master

Arjan van de Ven (3):
      Revert "fastboot: Make libata initialization even more async"
      Revert "fastboot: make the libata port scan asynchronous"
      partial revert of asynchronous inode delete

 drivers/ata/libata-core.c |   96
 +++++++++++++++++++++------------------------
 fs/inode.c                |   19 +++------ 2 files changed, 51
 insertions(+), 64 deletions(-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
