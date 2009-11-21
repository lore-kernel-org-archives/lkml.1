Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZKVMSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZKVMSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZKVMSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:18:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57514 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZKVMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=NGxSvERsM2cW3x656+BNv2U5Pq8+vFvlG2cVlZdjWhVMmKF9NiwXSFTK2a0N4EegnT
         VesaNa29sGUcfGNPRQpLNqPcOd1ZhJBVn0ZrH9SQkXfNyc0YPPpdhRX/D4dfE1E/6ay4
         hO80dg3oyDeVhcRsJzJaeq0ojdhhirtI4jCh4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 0/2] pid: tighten pidmap spinlock section and clean up
Date: Sat, 21 Nov 2009 10:16:18 -0200
Message-Id: <cover.1258805412.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.3.298.g39add
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid calling kfree() from under pidmap spinlock and reduces code size
by 16 bytes on gcc 4.4.1 on Core 2.

André Goddard Rosa (2):
  pid: tighten pidmap spinlock critical section by removing kfree()
  pid: reduce code size by using a pointer to iterate over array

 kernel/pid.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

