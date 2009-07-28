Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZG1FIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZG1FIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZG1FIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:08:30 -0400
Received: from imp01.mtu.ru ([62.5.255.10]:47448 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZG1FIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:08:30 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH]  type without #include <linux/types.h>
Content-Disposition: inline
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
Date: Tue, 28 Jul 2009 09:08:25 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907280908.27412.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC warning In latest git - 2.6.31-rc4: 

include/linux/pps.h:52: found __[us]{8,16,32,64}  
type without #include <linux/types.h>


diff --git a/include/linux/pps.h b/include/linux/pps.h
index cfe5c72..bef47e2 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -48,6 +48,9 @@
  * The simple fix is probably to add an explicit padding.
  *                                                     [David Woodhouse]
  */
+
+#include <linux/types.h>
+
 struct pps_ktime {
        __s64 sec;
        __s32 nsec;

--- 
Signed-of: pavel@pavlinux.ru
