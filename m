Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbXLPKJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbXLPKJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXLPKJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:09:05 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3912 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbXLPKJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:09:04 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Sun, 16 Dec 2007 11:11:02 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161111.02770.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	cat /proc/kpageflags on sparc64 causes the box to lock.
I can not write on any terminal - but I can issue sysrqs and switch
between consoles.

cat process hangs in read(3, ...

sysrq-w shows:

syslogd       D 000000000069240c     0  2470      1
Call Trace:
 [0000000000692224] 
 [0000000000692224] 
 [0000000000692224] 
 [0000000000692224] 
 [0000000000692224] 
 [0000000000692224] 
