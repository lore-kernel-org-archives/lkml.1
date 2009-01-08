Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZAHCKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZAHCKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZAHCKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:10:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43444 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZAHCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:10:30 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/3] document sysrq interaction with loglevels V2
Date: Thu,  8 Jan 2009 02:10:23 +0000
Message-Id: <1231380626-20597-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-reply-to: <20090107205030.GE12402@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Updated patch series incorporating feedback from Martin Mares and Randy
Dunlap.]

Following on from our discussion on sysrq and its interaction with
console loglevels here are some documentation updates, both to the
Documenation/sysrq.txt as well as to the source, to clarify how things
work and why.

Following this email are three patches.  The first simply removes a
redundant 'last modified date' within the documentation file, git does
this far better.  The second adds a new documentation section indicating
why you might only see the header of the sysrq command you have requested.
The last adds a comment to the console_loglevel modifications within the
sysrq code paths explaining why we might do this.

Andrew please consider for -mm.

-apw

Andy Whitcroft (3):
  sysrq documentation: remove the redundant updated date
  sysrq documentation: document why the command header only is shown
  sysrq: add commentary on why we use the console loglevel over using
    KERN_EMERG

 Documentation/sysrq.txt |   19 ++++++++++++++++++-
 drivers/char/sysrq.c    |    6 ++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

