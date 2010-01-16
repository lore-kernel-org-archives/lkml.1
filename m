Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0APNkY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066Ab0APNkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:40:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47266 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0APNkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=paLkrERSB9t/F/Me+3IBDSIn5HQaOfB2HABkfaW0ktdPLpgLgVa9HE3LeY2HB7S76K
         QfydS0ELcTLpWdL5oqgmpBYEVL6ASEaxzLXh2zbKqWRdWkOhyPYCKLBYm1YNitpdT7In
         3cyzBBflVxdIrzrelQg+s6sIyEDiubUmzNb/o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [GIT PULL] perf event scheduling updates
Date: Sat, 16 Jan 2010 14:40:05 +0100
Message-Id: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/scheduling branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/scheduling

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      perf/core: Split context's event group list into pinned and non-pinned lists
      list: Introduce list_rotate_left()
      perf: Round robin flexible groups of events using list_rotate_left()
      perf: Export software-only event group characteristic as a flag


 include/linux/list.h       |   14 +++
 include/linux/perf_event.h |    8 +-
 kernel/perf_event.c        |  262 +++++++++++++++++++++++++++-----------------
 3 files changed, 181 insertions(+), 103 deletions(-)
