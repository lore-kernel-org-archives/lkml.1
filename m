Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZLNH6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZLNH6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZLNH6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:58:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:58266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbZLNH6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:58:40 -0500
Date: Mon, 14 Dec 2009 07:58:01 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
       amwang@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, amwang@redhat.com,
       mingo@elte.hu
In-Reply-To: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
References: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove usedac in feature-removal-schedule.txt
Message-ID: <tip-06f8bda8324fa8bf39eed81d8b3df08063a37696@git.kernel.org>
Git-Commit-ID: 06f8bda8324fa8bf39eed81d8b3df08063a37696
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06f8bda8324fa8bf39eed81d8b3df08063a37696
Gitweb:     http://git.kernel.org/tip/06f8bda8324fa8bf39eed81d8b3df08063a37696
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 14 Dec 2009 11:06:15 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:53:54 +0100

x86: Remove usedac in feature-removal-schedule.txt

The reason of removal, "replaced by allowdac and no dac
combination" is incorrect. There is no way to do the same thing
with "allowdac" and "nodac" combination.

The usedac option enables us to stop via_no_dac() setting
forbid_dac to 1. That is, someone who uses VIA bridges can use
DAC with this option even if some of VIA bridges seem to be
broken about DAC.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: gcosta@redhat.com
LKML-Reference: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2a4d779..eb2c138 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	usedac i386 kernel parameter
-When:	2.6.27
-Why:	replaced by allowdac and no dac combination
-Who:	Glauber Costa <gcosta@redhat.com>
-
----------------------------
-
 What: print_fn_descriptor_symbol()
 When: October 2009
 Why:  The %pF vsprintf format provides the same functionality in a
