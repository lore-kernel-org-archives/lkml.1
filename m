Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYFTMw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYFTMw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYFTMv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:51:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYFTMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:51:54 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH 0/2] parport sparse fixes
Date: Fri, 20 Jun 2008 14:51:43 +0200
Message-Id: <cover.1213965527.git.andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX19g1tEeTets+UDxM9/I7ir0Nfbv2DDESrUcD6d
 y/cPkFrlc4sNoOZBbiz7aM0muRy+d/OVFB28Cc1y3XRonfi71q
 bec91znIxOx8JmPKPcV+TscOwAS3ICjFA5AqyxNOV0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix some warnings sparse gave me, when running
over drivers/parport.

Andre Haupt (2):
  parport: remove superfluous local variable.
  parport: make parport_cs_release static.

 drivers/parport/ieee1284.c   |    2 --
 drivers/parport/parport_cs.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

