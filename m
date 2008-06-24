Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYFXOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYFXOQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYFXOP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:15:58 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:4999 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYFXOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:15:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/3] RT: scheduler newidle enhancements v2
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com,
       npiggin@suse.de
Date: Tue, 24 Jun 2008 08:15:57 -0600
Message-ID: <20080624141527.28487.77778.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

 Here is v2 of the newidle patches I sent out yesterday:

http://lkml.org/lkml/2008/6/23/392

Changes since v1:

1) Added a new patch (1/3) for limiting balance operations to sd->span
2) Updated prologue to 2/3 according to comments from PeterZ.
3) Enhanced 2/3 by reducing the amount of unlock/lock cycles
4) Enhanced 2/3 by checking for need_resched() before taking the double-lock

Comments/feedback/bug-fixes welcome.

Regards,
-Greg

