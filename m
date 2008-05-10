Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbYEJDT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbYEJDT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbYEJDMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:12:15 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:58161 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782AbYEJDMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:12:13 -0400
X-Originating-IP: [74.251.48.254]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, csnook@redhat.com,
       pelle@dsv.su.se
Subject: [PATCH 0/4] atl1: fix suspend, resume, wake-on-lan
Date: Fri,  9 May 2008 22:12:05 -0500
Message-Id: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches fix suspend, resume, and wake-on-lan. Please merge for 2.6.27.

Diffstat

 drivers/net/atlx/atl1.c |  157 +++++++++++++++++++++++++++++------------------
 drivers/net/atlx/atl1.h |    2 +-
 drivers/net/atlx/atlx.c |    2 +-
 drivers/net/atlx/atlx.h |    7 ++-
 4 files changed, 105 insertions(+), 63 deletions(-)

