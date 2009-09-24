Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbZIXQBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbZIXQBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZIXQBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZIXQB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:01:28 -0400
Date: Thu, 24 Sep 2009 18:01:14 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH 0/3]Share common code between builtin-report,
 builtin-annotate
Message-ID: <alpine.LFD.2.00.0909241744030.11383@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-annotate.c started out largely as a copy of builtin-report.c
In the meantime, fixes and enhancements have gone into builtin-report but 
not always into builtin-annotate

The goal here it to share code where possible. The first step is these 
three patches - more work is comming.

These three patches add util/sort.c and util/sort.h and move that 
functionality out of builtin-report and builtin-annotate.

