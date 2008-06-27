Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYF0APX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYF0APX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYF0APJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:15:09 -0400
Received: from saeurebad.de ([85.214.36.134]:59892 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYF0API (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:15:08 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 02:08:05 2008
Message-Id: <20080627000445.346130358@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 02:04:45 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3] softlockup fixlets
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000003, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are three small fixlets for the softlockup watchdog that fell out
while studying the code.

	Hannes

 arch/x86/kernel/nmi_32.c |    2 +-
 arch/x86/kernel/nmi_64.c |    2 +-
 include/linux/nmi.h      |    2 +-
 include/linux/sched.h    |    4 ++++
 kernel/softlockup.c      |   25 +++++++++++++------------
 5 files changed, 20 insertions(+), 15 deletions(-)

