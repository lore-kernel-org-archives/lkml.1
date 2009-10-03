Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbZJCNra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbZJCNra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZJCNr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:47:29 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:35853 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbZJCNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eBrQCjiJIo3zmV9Bv5d0K/+NvFWGR3uL01NicwF19hY59UfY2mOfsyIgqTc6fcoxa9
         YkjXoAJSN+J7QkdHu2RugjUTmbTKglfLTx1DV5r08d+LPIsMKF1m2cc5aLesNLZ4twW2
         f6crFBhVfazLazT4tMoWraIsLN3G9+7NBxbpM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] tracing: Perf tracing fixes
Date: Sat,  3 Oct 2009 15:47:28 +0200
Message-Id: <1254577650-5623-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull these .33 tracing fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

These address reviews from Paul mackerras.

I also plan to rename the whole "ftrace event profile" naming to
"ftrace event perf" soon.

Thanks.

Frederic Weisbecker (2):
      tracing: Check total refcount before releasing bufs in profile_enable failure
      tracing: Use free_percpu instead of kfree

 kernel/trace/trace_event_profile.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)
