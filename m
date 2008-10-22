Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJVKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJVKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJVKAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:00:46 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:28697 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJVKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:00:45 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/7] x86, dumpstack: unify oops_begin, oops_end, die_nmi and die
Date: Wed, 22 Oct 2008 12:00:07 +0200
Message-Id: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20081021145954.GB25750@hmsreliant.think-freely.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 11:59:10 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Neil, Ingo, everyone,

This patch series unifies oops_begin, oops_end, die_nmi
and die in dumpstack_xx.c. The first patch might be
considered a bug-fix, because otherwise, as Neil Horman
points out, it might be possible to call crash_kexec with
the console_sem held; if that happens, we deadlock.

Greetings,
	Alexander
