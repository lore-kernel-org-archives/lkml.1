Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYJFXMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYJFXMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYJFXLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:11:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYJFXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:11:50 -0400
Message-Id: <20081006230610.024517480@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Oct 2008 19:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] ftrace: separate ftrace from ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been a lot of confusion between ftrace the infrastructure and
ftrace the function tracer within ftrace.  Developers have added
dependencies on HAVE_FTRACE when they did not need to. The HAVE_FTRACE
was the architecture supported the function tracer.

This patch series renames the ftrace function tracer to just that,
FUNCTION_TRACER.  And even renames the tracer shown to users from
'ftrace' to 'function'.

Now, when referring to ftrace, it means the ftrace infrastructure, and
when referring to the function trace, it is now called the
function tracer.

The second patch cause a lot of files to be touched. Mostly Makefiles and
Kconfig files. As well as default configs.

-- Steve

