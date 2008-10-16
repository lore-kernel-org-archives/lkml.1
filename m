Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYJPSbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYJPSbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJPSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:31:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:54846 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYJPSbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:31:16 -0400
Date: Thu, 16 Oct 2008 12:31:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [Pull] Documentation tree
Message-ID: <20081016123114.4841bc93@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

The latest version of my documentation tree can be pulled from:

  git://git.lwn.net/linux-2.6.git docs

It contains the development process document, the removal of the V4L1
document, and a number of other documentation-related patches I've
picked up from the list.

Alberto Bertogli (1):
      Documentation/block/data-integrity.txt: Fix section numbers

Andi Kleen (2):
      Add kerneldoc documentation for new printk format extensions
      Add a reference to paper to SubmittingPatches

Bernhard Walle (1):
      Document panic_on_unrecovered_nmi sysctl

Hidetoshi Seto (1):
      doc: Test-by?

Jonathan Corbet (2):
      Add the development process document
      Remove videobook.tmpl

 Documentation/00-INDEX                             |    3 +
 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/videobook.tmpl               | 1654 --------------------
 Documentation/SubmittingPatches                    |    7 +-
 Documentation/block/data-integrity.txt             |    4 +-
 Documentation/development-process/1.Intro          |  274 ++++
 Documentation/development-process/2.Process        |  459 ++++++
 Documentation/development-process/3.Early-stage    |  195 +++
 Documentation/development-process/4.Coding         |  384 +++++
 Documentation/development-process/5.Posting        |  278 ++++
 Documentation/development-process/6.Followthrough  |  202 +++
 Documentation/development-process/7.AdvancedTopics |  173 ++
 Documentation/development-process/8.Conclusion     |   74 +
 Documentation/filesystems/proc.txt                 |   12 +
 kernel/printk.c                                    |    2 +
 lib/vsprintf.c                                     |   12 +
 16 files changed, 2077 insertions(+), 1658 deletions(-)
 delete mode 100644 Documentation/DocBook/videobook.tmpl
 create mode 100644 Documentation/development-process/1.Intro
 create mode 100644 Documentation/development-process/2.Process
 create mode 100644 Documentation/development-process/3.Early-stage
 create mode 100644 Documentation/development-process/4.Coding
 create mode 100644 Documentation/development-process/5.Posting
 create mode 100644 Documentation/development-process/6.Followthrough
 create mode 100644 Documentation/development-process/7.AdvancedTopics
 create mode 100644 Documentation/development-process/8.Conclusion
