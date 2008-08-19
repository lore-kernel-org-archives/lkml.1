Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYHSVQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYHSVQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbYHSVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:16:14 -0400
Received: from www17.your-server.de ([213.133.104.17]:37424 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbYHSVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:16:13 -0400
Message-ID: <1219180571.48ab381bd85e5@213.133.104.17>
Date: Tue, 19 Aug 2008 23:16:11 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Subject: Fwd: 2.6.26.3: ACPI: Fix thermal shutdowns
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 79.220.116.228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi.

This one should go in 2.6.26.3, too:

I didn't see it in Greg's list:

ACPI: Fix thermal shutdowns

Do not use unsigned int if there is test for negative number...

See drivers/acpi/processor_perflib.c
  static unsigned int ignore_ppc = -1;
...
  if (event == CPUFREQ_START && ignore_ppc <= 0) {
       ignore_ppc = 0;
...


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21

Greets
thomas

