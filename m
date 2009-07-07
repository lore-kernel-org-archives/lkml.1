Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZGGPja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZGGPja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbZGGPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:39:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40454 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758445AbZGGPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:39:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Series short description
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 16:39:16 +0100
Message-ID: <20090707153625.3642.70750.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next couple of fixes. The pty one is a bit more dramatic than I wanted for
an -rc release but it actually fixes the problem and at this point seems lower
risk than trying to botch up the existing code temporarily.

Having applied thar you can also then revert
a6540f731d506d9e82444cf0020e716613d4c46c

There are some USB patches to follow to fix various messes caused by sysrq
changes (serious performance regression and a kref leak) but I want those in
-next for a few days first.

---

Alan Cox (2):
      tty: maintainers data was edited wrongly by someone
      pty: Rework the pty layer to use the normal buffering logic


 MAINTAINERS        |   10 ++-
 drivers/char/pty.c |  156 ++++++++++++++++++++--------------------------------
 2 files changed, 65 insertions(+), 101 deletions(-)

-- 
My telephone support is a table

