Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0BXHIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:08:04 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:34197 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab0BXHIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=rcETivuTg2evIVlIMJFqQJr8m7/PDNIz8PNNyTI+2EzM6uys2+BdtPMd2ybR+F7Dxz
         hyZ+xrm/69TZUhqCC/KSug0QsIq3fKtfgu6dSGLY/YnXAvH2PG0JF2Hs7UOXxaDG87j3
         O3/YBFtUVqReF28iccbcUVgwjsYATiCOHkOFg=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 0/6] Fix file descriptor leak on user-space processes and cleanup 
Date: Tue, 23 Feb 2010 04:04:22 -0300
Message-Id: <cover.1266907495.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a file descriptor leak on user-space processes and perform a cleanup,
reducing the code size:
text    data     bss     dec     hex filename
9949      72      16   10037    2735 ipc/mqueue-BEFORE.o
9885      72      16    9973    26f5 ipc/mqueue-AFTER.o

André Goddard Rosa (6):
  mqueue: remove unneeded info->messages initialization
  mqueue: apply mathematics distributivity on mq_bytes calculation
  mqueue: simplify do_open() error handling
  mqueue: only set error codes if they are really necessary
  mqueue: fix typo "failues" -> "failures"
  mqueue: fix mq_open() file descriptor leak on user-space processes

