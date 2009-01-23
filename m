Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbZAWLCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbZAWLCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761483AbZAWLBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:01:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:10621 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZAWLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PdZv5F5RmwBRXtNU4Vl5zSZb0n9eRyf7xKy6MykbgRgPh1VDXIY15/afCA9zbQ4Bp5
         mhyIguIbwXFlplzH1kjZQB8WeeA4Y6nt7BKAa1oQ1AD/lYzKbfuD9nuxk5ztudOUE0cD
         Rf1a5ws3jw6oN8ZR/xjFb6jC/SzAu7xaJZCdU=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, gregkh@suse.de,
       roel.kluin@gmail.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com, Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 23 Jan 2009 19:59:02 +0900
Message-Id: <20090123105902.18779.22264.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 008/011] sh: add early platform support for earlyprintk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds early platform "earlyprintk" class support.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/setup.c |    3 +++
 1 file changed, 3 insertions(+)

--- 0021/arch/sh/kernel/setup.c
+++ work/arch/sh/kernel/setup.c	2009-01-23 16:38:16.000000000 +0900
@@ -389,6 +389,9 @@ void __init setup_arch(char **cmdline_p)
 
 	plat_early_device_setup();
 
+	/* Let earlyprintk output early console messages */
+	early_platform_driver_probe("earlyprintk", 1, 1);
+
 	sh_mv_setup();
 
 	/*
