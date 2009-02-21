Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZBUBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZBUBSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZBUBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:18:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:17406 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZBUBSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:18:04 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/2] KVM: fix sparse warnings
To: Avi Kivity <avi@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 02:17:58 +0100
Message-ID: <20090221011723.7022.97639.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix some sparse warnings in KVM.

---

Hannes Eder (2):
      KVM: fix sparse warnings: Should it be static?
      KVM: fix sparse warnings: context imbalance


 arch/x86/kvm/i8259.c |    2 ++
 arch/x86/kvm/mmu.c   |   11 ++++++-----
 arch/x86/kvm/x86.c   |    8 ++++----
 virt/kvm/irq_comm.c  |    4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)
