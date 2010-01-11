Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304Ab0AKUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0AKUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259Ab0AKUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:21:18 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36112 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0AKUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:21:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Ay9JdTPTkSjlYt+9sjByf0IiX4DAQCKC7699PkjbkPI3lDuyPNhzsZKs37tPURTyIO
         y+i7ehasvYbBOIXENto/dfkO7AxZLYkACFlplsmwqT75rBIyWd175J7y1WvI6otz3nnn
         GdTXJULz9C3w6WiZjkMswjPY3C6vOAMBWqj/Y=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/2] Minor clean-ups in plist and spinlock
Date: Mon, 11 Jan 2010 21:21:05 +0100
Message-Id: <1263241267-25204-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas / Ingo

These patches clean-up some minor problems.
They are safe for 2.6.33, but can also wait for 2.6.34.
They should also be applied to the -rt branch until accepted upstream.

They can be pulled at
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
branch: jk/v2.6.33-rc3-cleanups

John Kacur (2):
  plist: Fix grammar mistake, and c-style mistake.
  spinlock: Fix some indentation problems in spinlock.h

 include/linux/plist.h    |    4 ++--
 include/linux/spinlock.h |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

