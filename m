Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYJATym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYJATym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYJATyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:54:33 -0400
Received: from vena.lwn.net ([206.168.112.25]:47131 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbYJATyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:54:33 -0400
Date: Wed, 1 Oct 2008 13:54:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       Alberto Bertogli <albertito@blitiri.com.ar>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PULL] Documentation
Message-ID: <20081001135430.6e2b2493@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My documentation tree contains the development process document I wrote
back in June; it has been reviewed on the list a couple of times and
published by the Linux Foundation.  I've also put in a few docs changes
from others that I have run across.  I can guarantee it will cause no
2.6.27 regressions, but there is also no real reason why it can't wait
until the merge window opens.

jon

The following changes are available in the git repository at:

  git://git.lwn.net/linux-2.6.git docs

Alberto Bertogli (1):
      Documentation/block/data-integrity.txt: Fix section numbers

Hidetoshi Seto (1):
      doc: Test-by?

Jonathan Corbet (1):
      Add the development process document

Michael Kerrisk (2):
      SubmitChecklist: interfaces changes should CC linux-api@
      Documentation/HOWTO: info about interface changes should CC linux-api@vger

 Documentation/00-INDEX                             |    3 +
 Documentation/HOWTO                                |    3 +-
 Documentation/SubmitChecklist                      |    2 +
 Documentation/SubmittingPatches                    |    2 +-
 Documentation/block/data-integrity.txt             |    4 +-
 Documentation/development-process/1.Intro          |  274 ++++++++++++
 Documentation/development-process/2.Process        |  459 ++++++++++++++++++++
 Documentation/development-process/3.Early-stage    |  195 +++++++++
 Documentation/development-process/4.Coding         |  384 ++++++++++++++++
 Documentation/development-process/5.Posting        |  278 ++++++++++++
 Documentation/development-process/6.Followthrough  |  202 +++++++++
 Documentation/development-process/7.AdvancedTopics |  173 ++++++++
 Documentation/development-process/8.Conclusion     |   74 ++++
 13 files changed, 2049 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/development-process/1.Intro
 create mode 100644 Documentation/development-process/2.Process
 create mode 100644 Documentation/development-process/3.Early-stage
 create mode 100644 Documentation/development-process/4.Coding
 create mode 100644 Documentation/development-process/5.Posting
 create mode 100644 Documentation/development-process/6.Followthrough
 create mode 100644 Documentation/development-process/7.AdvancedTopics
 create mode 100644 Documentation/development-process/8.Conclusion
