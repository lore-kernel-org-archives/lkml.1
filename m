Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZC0Onp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZC0Onp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbZC0Onb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:43:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63728 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536AbZC0On2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:43:28 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/2] omap: twl4030_wdt: driver implementation
Date: Fri, 27 Mar 2009 16:42:16 +0200
Message-Id: <1238164938-11932-1-git-send-email-ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 27 Mar 2009 14:42:59.0546 (UTC) FILETIME=[53092BA0:01C9AEEA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the simplest implementation of twl4030 watchdog driver.
Using this driver, the watchdog can be enabled/kicked/disabled,
but it does not take care of whether OFF-to-ACTIVE transition
will take place or not. Neither it supports the configuration
of PRETIMEOUT.


