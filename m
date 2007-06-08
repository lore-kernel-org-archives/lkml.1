Return-Path: <linux-kernel-owner+w=401wt.eu-S1030959AbXFHWZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030959AbXFHWZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936509AbXFHWZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:25:34 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:41930
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968913AbXFHWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:25:32 -0400
Message-ID: <4669D741.9070807@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:25:05 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 6/7] Add pr_debug_pid to kernel.h
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
+static inline int __attribute__ ((format (printf, 1, 2)))
pr_debug_pid(const char * fmt, ...)
+{
+	return 0;
+}
+
 static inline int __attribute__ ((format (printf, 1, 2))) pr_err(const
char * fmt, ...)
 {
 	return 0;

-- 
