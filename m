Return-Path: <linux-kernel-owner+w=401wt.eu-S1762581AbXJEOlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762581AbXJEOlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXJEOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:41:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:47982 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751495AbXJEOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:41:39 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1855FIbNOw5qG6abzgWvvx7J7+dKFBnu1nJHC64rP
	bqPlI+LECfTGzH
Date: Fri, 5 Oct 2007 16:41:58 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@poirot.grange
To: linux-kernel@vger.kernel.org
Subject: tmpfs disabled in .config but in /proc/filesystems
Message-ID: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am I running crazy here (some 2.6.23-rc6-ish)?

$ zcat /proc/config.gz | grep TMPFS
# CONFIG_TMPFS is not set
$ grep tmpfs /proc/filesystems
nodev   tmpfs

Thanks
Guennadi
---
Guennadi Liakhovetski
