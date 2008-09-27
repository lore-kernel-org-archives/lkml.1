Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYI0OW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYI0OW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 10:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYI0OWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 10:22:33 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:48401 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYI0OWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 10:22:30 -0400
X-Originating-IP: [74.251.44.253]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, jie.yang@atheros.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 0/4] atl1: miscellaneous fixes and updates 
Date: Sat, 27 Sep 2008 09:17:19 -0500
Message-Id: <1222525043-4648-1-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please accept this patchset for the atl1 driver. It includes a bugfix
for transmit timeouts reported by Alexey Dobriyan, removal of LLTX
(inspired by Kevin Hao's removal of same from atl2), removal of the
EXPERIMENTAL tag (initially submitted in slightly different form by
Chris Snook, but somehow lost), and an update to the driver's
introductory comments.

Jay Cliburn (4):
  atl1: fix transmit timeout bug
  atl1: remove LLTX
  atl1: remove EXPERIMENTAL label
  atl1: update introductory comments

 drivers/net/Kconfig     |    7 ++++---
 drivers/net/atlx/atl1.c |   32 +++++++-------------------------
 drivers/net/atlx/atlx.c |    1 -
 3 files changed, 11 insertions(+), 29 deletions(-)

