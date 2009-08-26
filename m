Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZHZLcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZHZLcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932084AbZHZLcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:32:50 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:47241 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbZHZLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:32:49 -0400
Date: Wed, 26 Aug 2009 20:32:51 +0900 (JST)
Message-Id: <20090826.203251.260094379.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: ioband-devel@lists.sourceforge.net, osonoi@linux-foundation.jp,
       kunai@linux-foundation.jp, corsetproject@googlegroups.com
Subject: IO controller Mini-Summit 2009
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

As I have notified before, The 1st Linux IO controller Mini-Summit
will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
kernel summit. So I would like to propose the following topics for 
the mini-summit and discuss about them.

- Multiple IO controller development projects
  - There are two activities for the development of IO controller,
    Vivek's io-controller and dm-ioband. Do we have to pick one of
    them to put into the mainline? How to advance the development?

- Extensions of struct bio
  - Make a bio point to the io_context of a process which creates the
    I/O request. This allows to pass the IO scheduling class and
    priority information to IO controller even if the IO is submitted
    by another process which does not create the request, such as a
    worker thread.
  - Add a new flag to struct bio to identify the bio as urgent. This
    gives IO controller a chance to handle the bio as high priority.
    This flag should be set if the bio is created for the page-out
    operation.

- I/O tracking and charging policy
  - Which process, a page-requesting process or a page-returning
    process, should be charged for the I/O caused by page reclaim?
    We should consider two cases where the IO flushes anonymous pages
    and file mapped pages.

I think this is a good opportunity to meet face-to-face to discuss
about IO controller development. I would like to many developers to
join this mini-summit. Please visit the following URL for more
information about the mini-summit.
http://apps.sourceforge.net/trac/ioband/wiki/iosummit
If you would like to join the mini-summit, please e-mail to me or post
on the wiki page, 
(You need an account on SourceForge.net to edit the wiki page.)

All comments, questions, suggestions and anything else are appreciated.

Thanks,
Ryo Tsuruta
