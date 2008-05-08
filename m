Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYEHNHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYEHNHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYEHNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:07:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:29894 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYEHNHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type:content-transfer-encoding:x-mailer;
        b=UntPZvMqenf/wab8Fud6B8nKEUPthYK26w4ovvpk2MRkuUX7+isPJgEQxRbpmJ0GeAj1KITtfAR/SKacDHmKjsesYH8+NTShY2YC9qM78zIHCrlYYy5STmmlgcL9co5GkrmuoNgJyX2E9rVdSgmG6aj+vJikFS6GYaR+yUQBaSQ=
Date: Thu, 08 May 2008 21:07:01 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: dipankar@in.ibm.com
Subject: [RCU] remove duplicated include in kernel/rcupreempt.c
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080508210503.8956.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include file <linux/rcupdate.h> in kernel/rcupreempt.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

--- a/kernel/rcupreempt.c       2008-05-08 20:43:54.000000000 +0800
+++ b/kernel/rcupreempt.c       2008-05-08 20:44:24.000000000 +0800
@@ -50,7 +50,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>


