Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYKPEwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYKPEwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKPEv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:51:59 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:57308 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKPEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Iz/WiwLfU5NDNjYalpgdSC7Xz5oKfWdjAQiEJFrqKDCYaFVscjvj57zC9bzTVZYt+v
         12aydFQ3GT0ZwbhMFnbyK6HZmvny1Hbnrt7P4YdQ7joBreYuhVvrWfOGKint5vxs84Hb
         qOAUyh5dQ/TYmS1yXZF3oxKSfm2a6ntpXGGp8=
Message-ID: <491FA6E8.2010506@gmail.com>
Date: Sun, 16 Nov 2008 05:51:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Various fixes and enhancements for tracing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies on latest -tip (and normally against latest Steven's tracing tree).

_ tracing/ftrace: Fixes unexpected -EINVAL when longest tracer name is set
_ tracing/ftrace: Change the type of the init() callback
_ tracing/branch-tracer: Fix a trace recursion on branch tracer
_ tracing/function-return-tracer: Support for dynamic ftrace on function return tracer

The first and the third are bug fixes and the others are submitted for purposes on improvement for
tracing and the function return tracer.
Note that I kept the "return" name for the names used in the last patch because we haven't yet
decided what could be the better name. But once we find it, I will change the name of data structures
and functions used by this tracer.
