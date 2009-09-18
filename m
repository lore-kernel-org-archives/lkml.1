Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbZIREYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbZIREYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 00:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZIREYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 00:24:15 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46750 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZIREYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 00:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SmUd5p1QTq0RyDxAivvE3OLUIInwQ1EGX/kLuO8FvnNHl37li4FcunK32s6j2TOO50
         VCl5RJ4GgE+hx5/MifMasjAf4gqVqJGfeo5uZ0x6mWfRp4n9xguNE/1Kgph2eRyENFyG
         jftUkQmuGghO3Rhu6Bj/hpc2c6RNpC45d3Dt0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2 v2] tracing: Tracing event profiling updates
Date: Fri, 18 Sep 2009 06:24:12 +0200
Message-Id: <1253247854-5496-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please forget the previous pull request. This new one addresses
Steve's review.

Thanks,
	Frederic.

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core-v2

Frederic Weisbecker (2):
      tracing: Factorize the events profile accounting
      tracing: Allocate the ftrace event profile buffer dynamically

 include/linux/ftrace_event.h       |   10 +++-
 include/linux/syscalls.h           |   24 +++-----
 include/trace/ftrace.h             |  111 ++++++++++++++++++++---------------
 kernel/trace/trace_event_profile.c |   79 +++++++++++++++++++++++++-
 kernel/trace/trace_syscalls.c      |   97 +++++++++++++++++++++++++------
 5 files changed, 234 insertions(+), 87 deletions(-)
