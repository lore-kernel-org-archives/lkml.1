Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZDSWII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZDSWII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZDSWHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:07:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47264 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vm7gUCNLg7lXWcGudchjcZrDk2artzyXnaKHaJDd1RFJHc1M7mMxBD7f/5ix1QKoPu
         LJ+TxoQ1Xz8AnO0T3oEmsRzu9Zo6nD9jDm0jtmqNMrbmuZqPpgZPzVmf0WlVq4XCGqio
         5JMzxl0a4y/oNRAAol7C4kpjH9Gr7I1RTyA4k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] tracing: recursion protection fixes
Date: Mon, 20 Apr 2009 00:07:46 +0200
Message-Id: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two fixes for tracing recursion protection.
The first slightly improves debugging in case of recursion detection.
The second fixes a spurious warning and tracing disabling while
activating a filter.

The following changes since commit 8e668b5b3455207e4540fc7ccab9ecf70142f288:
  Steven Rostedt (1):
        tracing: remove format attribute of inline function

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/recursion

Frederic Weisbecker (2):
      tracing/core: Add current context on tracing recursion warning
      tracing/ring-buffer: unlock recursion protection on discard

 kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)
