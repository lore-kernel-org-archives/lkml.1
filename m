Return-Path: <linux-kernel-owner+w=401wt.eu-S970843AbXFHW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970843AbXFHW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970783AbXFHW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:28:14 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:41954
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970469AbXFHW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:28:13 -0400
Message-ID: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:18:31 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series replaces DPRINTK with pr_debug in alternative.c,
autofs, autofs4
and ncpfs. A new function called pr_err is also added to keep
functionality in
ncpfs. The last 2 patches add support for pr_debug_pid and apply it to
autofs4 to
keep the output the same as the current DPRINTK statements.

All patches have been compile tested but not boot tested

--
