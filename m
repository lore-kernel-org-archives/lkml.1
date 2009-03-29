Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZC2Xhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZC2Xhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 19:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZC2Xg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 19:36:57 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:41546 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbZC2Xg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 19:36:56 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49D004BB.3010505@lwfinger.net>
Date: Sun, 29 Mar 2009 18:31:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] kaweth: Fix locking and cleanup code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I dug out an old Peracom USB Ethernet Adapter, I was surprised to see that
it worked, but soon discovered that it generated several suspicious kernel log
messages.

The first of the 2 patches that follow incorporate changes in locking that allow
the device to be used on SMP systems. The second patch removes other errors that
were logged and cleans up the code a little.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
