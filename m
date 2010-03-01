Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0CASz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:55:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:18626 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0CASzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=lWq9a0Ro6vEvlc33x/p0tHV41e+temhcfPYtpBHCWRjq/VmdeiX0sqNnUsRaAXMiRu
         lqnmUoff1zgLV7Y/Xq+XyPNGefztXvnkoYVy3EkmHHVjjG/wZ/gc/T5bXwC9ENYY68n3
         VGkAhbeWF+NznBHC62//tDBeSdIjrj4OmmZec=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 0/5] Fix atomic64 return value conventions (v2)
Date: Mon,  1 Mar 2010 19:55:44 +0100
Message-Id: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- Resent patches with more verbose descriptions

This patchset fixes the return value conventions in the atomic64 test,
generic implementation and the x86-32 implementation in x86/tip/atomic.

Luca Barbieri (5):
  lib: fix atomic64_add_unless test
  x86-32: fix atomic64_add_unless return value convention
  lib: fix atomic64_add_unless return value convention
  lib: fix atomic64_inc_not_zero test
  x86-32: fix atomic64_inc_not_zero return value convention

 arch/x86/lib/atomic64_386_32.S |    7 +++----
 arch/x86/lib/atomic64_cx8_32.S |    7 +++----
 lib/atomic64.c                 |    4 ++--
 lib/atomic64_test.c            |   10 +++++-----
 4 files changed, 13 insertions(+), 15 deletions(-)

