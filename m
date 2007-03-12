Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbXCLVTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbXCLVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXCLVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:19:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXCLVTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:19:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] swsusp: Stop using page flags
Date: Mon, 12 Mar 2007 22:14:02 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122214.02657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches make swsusp use its own data structures for memory
management instead of special page flags, so that these page flags can be used
for other purposes.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

