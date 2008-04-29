Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYD2BWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYD2BWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYD2BWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:22:01 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:38932 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYD2BWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:22:01 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48167832.3090103@avtrex.com>
Date: Mon, 28 Apr 2008 18:21:54 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: [Patch 0/6] MIPS Hardware watchpoint support for gdb (version 2).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 01:21:55.0735 (UTC) FILETIME=[69A0A270:01C8A997]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second take at MIPS watch register support.

Changes from the previous version include:

* Change layout of structures used by ptrace to eliminate holes.

* Use [set|clear]_tsk_thread_flag() and friends instead of racy direct 
access.

* mips64 support (untested).

* Fix sparse warnings.

For this version of the patch you will need the corresponding gdb patch 
which can be found here:

http://sourceware.org/ml/gdb-patches/2008-04/msg00642.html

David Daney
