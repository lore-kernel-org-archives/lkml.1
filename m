Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZAAANy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZAAANy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZAAANo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:13:44 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:3551 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZAAANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H0bjl8cjlYXcmbFGAG+apEDQwzFizOBkJw+GCYdRnuHvVtOeqLSNpGuPRhqBgiZGUA
         f2ucXB/qIhvY7YRlFijBBzDrD2GgzLqzsUGO3DqNC9RRyDuJX+Z2E+P2iaalPp8BGp0w
         imk00XEUPacPxMcN5f2UizICnclj5Bpzxt7sc=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: PDA changes (take 2, resend)
Date: Wed, 31 Dec 2008 19:13:39 -0500
Message-Id: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the PDA patches again.  I changed the first patch so that the PDA is cacheline
aligned.  I dropped the cpunumber patch for now, and added conversions of the TLB state
and IRQ stats to match the 32-bit code.  Stats for defconfig:

  text    data     bss     dec     hex filename
7033649 1754476  758508 9546633  91ab89 vmlinux.before
7029643 1754716  758508 9542867  919cd3 vmlinux.after

Patches are against 2.6.28.

