Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYJ0Qlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYJ0Qlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYJ0QlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:41:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYJ0QlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:41:23 -0400
Message-Id: <20081027164233.132189000@napanee.usersys.redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 27 Oct 2008 12:42:33 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] IOAPIC NMI watchdog fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches make use of __acpi_nmi_disable() to make possible to:
- enable and disable IOAPIC NMI watchdog using procfs
- disable NMI generation if the NMI watchdog is not working on boot time

-- 
Aristeu

