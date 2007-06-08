Return-Path: <linux-kernel-owner+w=401wt.eu-S971437AbXFHWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971437AbXFHWd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971250AbXFHWdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:33:15 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:60893
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S971065AbXFHWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:33:14 -0400
Message-ID: <4669D6CB.7000007@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:23:07 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 4/7] Update DPRINTK macro to use pr_debug in autofs4
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
 #ifdef DEBUG
-#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt
"\n" , current->pid , __FUNCTION__ , ##args); } while(0)
+#define DPRINTK(fmt,args...) do { pr_debug("pid %d: %s: " fmt "\n" ,
current->pid , __FUNCTION__ , ##args); } while(0)
 #else
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif

-- 

