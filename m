Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYFHHTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYFHHTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 03:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYFHHTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 03:19:16 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53814 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYFHHTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 03:19:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18507.34830.260384.473257@frecb006361.adech.frec.bull.fr>
Date: Sun, 8 Jun 2008 09:19:42 +0200
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Solofo.Ramangalahy@bull.net, linux-kernel@vger.kernel.org,
       Matt Helsley <matthltc@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
In-Reply-To: <484A9D52.2020703@colorfullife.com>
References: <20080605145712.116223941@bull.net>
	<484A9D52.2020703@colorfullife.com>
X-Mailer: VM 7.19 under Emacs 23.0.50.1
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul writes:
 > > The size in bytes of a SysV IPC message queue, msgmnb, is too small
 > > for large machines, but we don't want to bloat small machines
 > >
 > > Several methods are used already to modify (mainly increase) msgmnb:
 > > . distribution specific patch
 > > . system wide sysctl.conf
 > > . application specific tuning via /proc/sys/kernel/msgmnb
 > >
 > >   
 > Which distributions use a patch?

opensuse has this:

"The defaults are too small for most users."

[...]
 #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
-#define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
-#define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
+#define MSGMAX  65536   /* <= INT_MAX */   /* max size of message (bytes) */
+#define MSGMNB 65536   /* <= INT_MAX */   /* default max size of a message queue */
[...]

-- 
solofo

