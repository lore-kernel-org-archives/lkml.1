Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbXLDNyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbXLDNyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXLDNyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbXLDNyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:24 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
Subject: [PATCH 0/10] Integrate msr.h
Date: Tue,  4 Dec 2007 09:09:54 -0200
Message-Id: <11967666042130-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series of patches integrates msr.h header.
What it really does, is a series of steps to allow us
to get rid of duplicate code between i386 and x86_64 versions

With this done, achieving paravirt for x86_64 gets really easy,
just a couple of extra code.

The first patch was already sent a while ago, but was not yet pushed
to any tree , to my knowledge. So it is sent again. Also, 
patches 9 and 10 relies on b02f15537b3bf43e347214cf14bad80aeaef1caf,
already in the x86 tree.

Other than that, it should apply fine ontop of linus today git.

Comments are welcome


