Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYFTMwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYFTMwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYFTMv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:51:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbYFTMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:51:54 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH 2/2] parport: make parport_cs_release static.
Date: Fri, 20 Jun 2008 14:51:45 +0200
Message-Id: <554789e3ddac9c52e5d843b9c6bc5aeb1191f2d2.1213965527.git.andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <15ef717cf17bfbbcdd49599ed9c99cc655b610fa.1213965527.git.andre@bitwigglers.org>
References: <cover.1213965527.git.andre@bitwigglers.org>
 <15ef717cf17bfbbcdd49599ed9c99cc655b610fa.1213965527.git.andre@bitwigglers.org>
In-Reply-To: <cover.1213965527.git.andre@bitwigglers.org>
References: <cover.1213965527.git.andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX1+6pwIwY7qZa7ruFSGTyFTYS0cahuh5jp8egeI
 CssFvYoWGVyDLf4GAe0YnoHvToEonDXy1eXszHRUpDMzkepfrM
 OWHpJAvFIku3xUHXcUAyhIRmjhQakvtMCaJsGyu3Mw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/parport/parport_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 802a81d..00e1d96 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -235,7 +235,7 @@ failed:
     
 ======================================================================*/
 
-void parport_cs_release(struct pcmcia_device *link)
+static void parport_cs_release(struct pcmcia_device *link)
 {
 	parport_info_t *info = link->priv;
 
-- 
1.5.5.GIT

