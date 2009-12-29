Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZL2PQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZL2PQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZL2PPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:15:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbZL2PPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:15:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.pdF.3mhOLB@chimera>
Subject: [Bug #14951] lockdep possible recursive lock in slab parent->list->rlock
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14951
Subject		: lockdep possible recursive lock in slab parent->list->rlock
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-12-27 12:06 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=126191560531463&w=4
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
Patch		: http://patchwork.kernel.org/patch/69829/


