Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYDUVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYDUVWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYDUVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:21:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYDUVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:21:33 -0400
Message-Id: <20080421210935.460817943@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Apr 2008 17:09:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/3] ftrace: overrun accounting and trace_pipe headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first patch in this series adds accounting to record overruns. That is
where the writing catches up to the reading of the buffer. This really
only matters for trace_pipe since that's a consumer / producer output file.

The next patch adds new methods for the plugins to hook into the
open_pipe and open_read, to let a plugin produce a header.
The open_read method can also be used to do something when overruns
are detected.

The last patch is a test patch AND SHOULD NOT BE APPLIED. It is just an
example in how to use the new methods to produce a header. It simply
makes the ftrace tracer produce a simple "Test header" before any
output.

-- Steve

