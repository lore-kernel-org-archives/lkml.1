Return-Path: <linux-kernel-owner+w=401wt.eu-S2993129AbXDYXSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993129AbXDYXSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993132AbXDYXSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:18:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22955 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993129AbXDYXSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:18:01 -0400
Date: Wed, 25 Apr 2007 16:21:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: johnpol@2ka.mipt.ru
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: W1 printk format warning
Message-Id: <20070425162104.168c32b6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in 2.6.21-rc7-mm1.  Are you aware of this?

drivers/w1/w1.c:460: warning: too few arguments for format

	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
		&sl->dev.bus_id[0]);

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
