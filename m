Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZCJQF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZCJQF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZCJQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:04:53 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18839 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZCJQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:04:52 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk
Subject: [PATCH 0/7] OMAP: watchdog driver fixes.
Date: Tue, 10 Mar 2009 18:03:50 +0200
Message-Id: <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 10 Mar 2009 16:04:31.0797 (UTC) FILETIME=[E605AE50:01C9A199]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset reorganizes slightly the code of omap_wdt driver,
introduces proper management of clocks and
CONFIG_WATCHDOG_NOWAYOUT + PM support, which was broken.
Also, inspired by numerous watchdog drivers using this technique, 
this patchset makes the NOWAYOUT behavior not to be restricted by kernel
configuration, but to be controlled by a module parameter.


