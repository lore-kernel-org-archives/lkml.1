Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbZHDPdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbZHDPdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbZHDPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:40064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864AbZHDPdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:47 -0400
Date: Tue, 4 Aug 2009 15:33:11 GMT
From: tip-bot for Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1248991326-26267-1-git-send-email-jirislaby@gmail.com>
References: <1248991326-26267-1-git-send-email-jirislaby@gmail.com>
Subject: [tip:irq/core] irq: Clean up by removing irqfixup MODULE_PARM_DESC()
Message-ID: <tip-990a55eb25d9698d61352264cc43f3a9c04cce90@git.kernel.org>
Git-Commit-ID: 990a55eb25d9698d61352264cc43f3a9c04cce90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:33:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  990a55eb25d9698d61352264cc43f3a9c04cce90
Gitweb:     http://git.kernel.org/tip/990a55eb25d9698d61352264cc43f3a9c04cce90
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Fri, 31 Jul 2009 00:02:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 17:00:11 +0200

irq: Clean up by removing irqfixup MODULE_PARM_DESC()

It's wrong (the parm takes no arguments) and compile-time wiped
away anyway (due to !MODULE).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
LKML-Reference: <1248991326-26267-1-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/spurious.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 4d56829..114e704 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -297,7 +297,6 @@ static int __init irqfixup_setup(char *str)
 
 __setup("irqfixup", irqfixup_setup);
 module_param(irqfixup, int, 0644);
-MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode, 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
