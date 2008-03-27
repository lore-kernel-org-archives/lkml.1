Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYC0RLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYC0RLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYC0RLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716AbYC0RLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH 0/9] integrate smp.h
Date: Thu, 27 Mar 2008 14:05:55 -0300
Message-Id: <12066375644061-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's the last series I was owing.

After that, smp_32.h and smp_64.h are gone, merged into smp.h
 
as usual, compiled tested in ~ 8 randconfigs for each architecture, and boot tested
in all my hardware.

enjoy

full diffstat:

a/include/asm-x86/smp_32.h |   12 -----
 a/include/asm-x86/smp_64.h |   12 -----
 b/arch/x86/xen/smp.c       |    7 +--
 b/include/asm-x86/smp.h    |   27 ++++++++++++
 b/include/asm-x86/smp_32.h |   27 ------------
 b/include/asm-x86/smp_64.h |    7 ++-
 include/asm-x86/smp.h      |   57 ++++++++++++++++++++++---
 include/asm-x86/smp_32.h   |   34 ---------------
 include/asm-x86/smp_64.h   |  100 ++++++++-------------------------------------
 9 files changed, 104 insertions(+), 179 deletions(-)

