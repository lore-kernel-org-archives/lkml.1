Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629Ab0A0UYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0A0UYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239Ab0A0UYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:24:38 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:32839 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0A0UYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aSL4JxbUFtB+a94+5sf0kExjgbfkK133A+QfuFdo060OBm+iGuKhL9jFf+wvU5KFlK
         SwKHHvzjlcqKkKGYFM3gGuT4jpvzduCADBKT6bFYS++dVBFOvkqR0vfJT1HEdGpcUtoh
         CFqIcuOtDncAhgd/axX5C+Ve/Qmm5fJuJMQkc=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <C.Emde@osadl.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/5] rt-tests: rt_numa.h clean-ups, and dependency files
Date: Wed, 27 Jan 2010 21:24:23 +0100
Message-Id: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches are mostly clean-up to our new rt_numa.h file.
We need to add a copyright notice in every file for some distributions.
This also creates some changes to simplify and clean-up
the differences between the code for the older LIBNUMA_API_VERSION and the
newer ones. (or at least I hope you will think so).
Finally there is a change to automatically generate dependencies for the
Makefile.

John Kacur (5):
  rt-tests: Add header including copyright notice to rt_numa.h
  rt-tests: Separate the #ifdef LIBNUMA_API_VERSION functions.
  rt-tests: Remove the ret variable, the end label and the goto.
  rt-tests: Fix some style problems, such as spaces instead of tabs.
  rt-tests: Automatically generate dependencies.

 Makefile                 |   20 ++++++++++++---
 src/cyclictest/rt_numa.h |   58 ++++++++++++++++++++++++++++-----------------
 2 files changed, 52 insertions(+), 26 deletions(-)

