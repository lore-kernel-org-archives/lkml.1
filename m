Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0CARPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:15:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59749 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0CARPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CNXqLYUsIPaLAvC2V75xBj2xsddwqqvAaklh4Qwl9WIsKiuVWvUgNvwYYKvV7DjE0f
         75OeoPX0IfuzWFYM2DKGGSiwrxjlwsQR6fMWux53z7zEySTpetPGDfo4zLhQ3suOlJp6
         Xvd5MjaphtdBb5ANPCxAX0dr0YE4i3l/4ZUEc=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 0/3] Fix atomic64_add_unless return value convention
Date: Mon,  1 Mar 2010 18:14:57 +0100
Message-Id: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return values 0 and 1 were swapped both in the generic implementation and
my x86-32 one.

The x86-32 and atomic64_test.c patches should probably be squashed in the
appropriate commits in tip/x86/atomic

Luca Barbieri (3):
  lib: fix atomic64_add_unless test
  x86: fix atomic64_add_unless return value convention
  lib: fix atomic64_add_unless return value convention

 arch/x86/lib/atomic64_386_32.S |    4 ++--
 arch/x86/lib/atomic64_cx8_32.S |    4 ++--
 lib/atomic64.c                 |    4 ++--
 lib/atomic64_test.c            |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

