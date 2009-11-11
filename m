Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZKKVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZKKVh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083AbZKKVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:37:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbZKKVhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:37:17 -0500
Date: Wed, 11 Nov 2009 22:31:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ptrace: syscall-exit && stepping fixes
Message-ID: <20091111213152.GA10639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently PTRACE_SINGLESTEP after syscall_exit stop is not consistent
across different machines, and we have different problems depending
on arch/.

As Roland suggests, we should move the arch-dependent logic into the
tracehook_report_syscall_exit() and unify/fix the behaviour.

Oleg.

