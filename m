Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbZAHXnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbZAHXnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZAHXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:42:51 -0500
Received: from vena.lwn.net ([206.168.112.25]:37346 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbZAHXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:42:50 -0500
Date: Thu, 8 Jan 2009 16:42:48 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Documentation tree for 2.6.29
Message-ID: <20090108164248.5184b65d@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

My documentation tree this time around has a couple of new documents
(RCU, bad memory) and a typo fix.  Please pull:

  git://git.lwn.net/linux-2.6.git docs-next

Jonathan Corbet (1):
      Fix a typo in the development process document.

Paul E. McKenney (1):
      Document RCU and unloadable modules

Pavel Machek (1):
      Document handling of bad memory

 Documentation/RCU/00-INDEX                 |    2 +
 Documentation/RCU/rcubarrier.txt           |  304 ++++++++++++++++++++++++++++
 Documentation/bad_memory.txt               |   45 ++++
 Documentation/development-process/4.Coding |    6 +-
 4 files changed, 354 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/RCU/rcubarrier.txt
 create mode 100644 Documentation/bad_memory.txt
