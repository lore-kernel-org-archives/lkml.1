Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYLaC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYLaC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYLaC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:59:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62713 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYLaC7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:59:04 -0500
Message-ID: <495ADF35.6090101@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 10:55:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] ftrace: support binary record (V2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binary record will save memory in trace buffer, and more events
can be recorded in buffer.

This patch add infrastructure for supporting binary record.

This infrastructure records events by binary and shows events
by human readable text.

And add a API ftrace_bprintk() using this infrastructure.
(This API is exactly the same as ftrace_printk(), beside it
record the date by binary)

changed from V1:
1) not use Python style. Formates typically have 2~8 '%',
   using Python style make no sense, and gcc can not check parameters
   when we use Python style.
2) enable ftrace trace markers.

patches are for tracing/ftrace.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---





