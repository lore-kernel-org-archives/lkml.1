Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab0CARab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:30:31 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65202 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0CARaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=neu0fXrPPAzuECj5inDBr6fal0S4VLhd8zdCtTpqyriTKy8MdQosjden4Ev7FvjSn8
         U4iGP9ypWpxpVYxAr2tY43wMTVh7VJRGopYi6Ej+0t5WgV+6MhGRbDldmdM1RzSEPEJ6
         YICS17wlkNW1EOXbxnWwdAVWpaS5Ar/pEnGak=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 0/2] x86-32: fix atomic64_inc_not_zero like add_unless
Date: Mon,  1 Mar 2010 18:30:17 +0100
Message-Id: <1267464619-6784-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was broken too.

Luca Barbieri (2):
  lib: fix atomic64_inc_not_zero test
  x86-32: fix atomic64_inc_not_zero return value convention

 arch/x86/lib/atomic64_386_32.S |    3 +--
 arch/x86/lib/atomic64_cx8_32.S |    3 +--
 lib/atomic64_test.c            |    6 +++---
 3 files changed, 5 insertions(+), 7 deletions(-)
