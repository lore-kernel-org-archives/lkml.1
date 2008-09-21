Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYIUQAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYIUQAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYIUQAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:00:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:25501 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYIUQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mJICDZRm2SCHLin8Pp+FYNVfG1PdXdBJ3Thkoh0rXs8OikFdmaM0Rw7+gWN8/YWpm0
         TLd0DrA+9bVee735BsdxnRs0Y2Pzht9TCVVmAdPf/aHHTa2YPj4FXoWB0I8M0v1Axgcb
         RtR0C3iGqYg9nUFFPD6fCbdTrTHNThFPE2Hb0=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 0/2] vgacon_scrolldelta cleanup
Date: Sun, 21 Sep 2008 18:00:07 +0200
Message-Id: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] vgacon: optimize scrolling
[PATCH 2/2] vgacon: vgacon_scrolldelta simplification

 drivers/video/console/vgacon.c |   48 ++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 24 deletions(-)
