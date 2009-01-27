Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZA0Qvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZA0Qvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZA0QvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:51:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:60259 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZA0QvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:51:06 -0500
Date: Tue, 27 Jan 2009 08:50:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
Subject: [pull request] async function call updates
Message-ID: <20090127085039.12759886@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following 4 patches for the async code; they contain 
two bugfixs (although the current kernel won't hit it in practice),
documentation and a rename of the "special" API to be more clear




The following changes since commit
5ee810072175042775e39bdd3eaaa68884c27805: Linus Torvalds (1):
        Fix "multiple definition of `debugfs_create_size_t'"

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-update.git  master

Cornelia Huck (4):
      async: Fix running list handling.
      async: Handle kthread_run() return codes.
      async: Add some documentation.
      async: Rename _special -> _domain for clarity.

 fs/super.c            |    4 +-
 include/linux/async.h |    8 +++--
 kernel/async.c        |   81
 +++++++++++++++++++++++++++++++++++++++++------- 3 files changed, 76
 insertions(+), 17 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
