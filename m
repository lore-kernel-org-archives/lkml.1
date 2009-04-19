Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZDSFBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZDSFBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 01:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZDSFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 01:01:41 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58354 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZDSFBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 01:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KZgUT797yrwt6g4pCaQY2XCVFDbkITm2ZGDV19L4z6bucRTG+uMF2qQvbdeY0ncdu/
         cNqWsGxCRKxlwKSjXxaLksurTGmQ+lp0Ew499orLlSZ5C31qpeuIk8XNauHgEwZqyXvP
         ZHj/1aaOs33b0lqkU3NE9yhDijMPd27vvWp9c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2 v3] [GIT PULL] tracing/events: add the __string field
Date: Sun, 19 Apr 2009 07:01:33 +0200
Message-Id: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the v3 of the __string() field patchset.
It applies suggestions from Steven and Peter with some arrangements.

This time, filtering is not supported (though it is ready in a pending patch).
I wanted to provide it but it looks like filtering has been broken recently.
Once I set a usual string filter, no more traces appear, and clearing it
doesn't change anything.

The following changes since commit 8e668b5b3455207e4540fc7ccab9ecf70142f288:
  Steven Rostedt (1):
        tracing: remove format attribute of inline function

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Frederic Weisbecker (2):
      tracing/events: provide string with undefined size support
      tracing/lock: provide lock_acquired event support for dynamic size string

 include/trace/events/lockdep.h |    6 +-
 include/trace/ftrace.h         |   88 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 6 deletions(-)
