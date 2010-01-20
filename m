Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302Ab0ATPmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0ATPmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681Ab0ATPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:41:59 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:63925 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0ATPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:41:58 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 10:41:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Z6r0gEBsLjQ67HTEj1bHDZfshSAeBiSksPImzdUUSMYIK1mGsW3340GKB0YGZwFG9K
         A01vCScMIRA7952qEULQKw87S497VC2hzdKyyV+ogAKsKjoGgiKmVxpCSYj+X1PLdQoW
         7ReZZ9botXx5hNKNxvSmrnQ36WZ7I2EKZz+qE=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <C.Emde@osadl.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       John Kacur <jkacur@redhat.com>
Subject: [rt-tests] [PATCH 0/2] Make numa a compiletime option
Date: Wed, 20 Jan 2010 16:36:22 +0100
Message-Id: <1264001784-11965-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for Clark's experimental numa branch of rt-tests.

It is important that numa be a compile time option, runtime checking is not
good enough, since most systems will not even have the numa libraries.

You can pull these patches from

pub/scm/linux/kernel/git/jkacur/rt-tests.git numa

John Kacur (2):
  rt-tests: Makefile: Add NUMA compile option.
  rt-tests: Make cyclic test compilable for non-numa systems.

 Makefile                    |    9 ++++-
 src/cyclictest/cyclictest.c |   46 +++++++-------------------
 src/cyclictest/rt_numa.h    |   74 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 35 deletions(-)
 create mode 100644 src/cyclictest/rt_numa.h

