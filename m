Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbYJWLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbYJWLwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYJWLwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:52:12 -0400
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:51552 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYJWLwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:52:10 -0400
Message-ID: <4900655E.7050906@freemail.hu>
Date: Thu, 23 Oct 2008 13:51:58 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cdrom: add TEAC CD-224E to the NO_AUTOCLOSE list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32711; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The "TEAC CD-ROM CD-224E" cannot close its tray, so add it to the NO_AUTOCLOSE list. This
will correct the "Can close tray" field of /proc/sys/dev/cdrom/info.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.27/drivers/ide/ide-cd.c.orig	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/ide/ide-cd.c	2008-10-23 11:34:59.000000000 +0200
@@ -1863,6 +1863,7 @@ static const struct cd_list_entry ide_cd
 	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "Optiarc DVD RW AD-7200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "Optiarc DVD RW AD-7543A", NULL,   IDE_AFLAG_NO_AUTOCLOSE	     },
+	{ "TEAC CD-ROM CD-224E",     NULL,   IDE_AFLAG_NO_AUTOCLOSE	     },
 	{ NULL, NULL, 0 }
 };

