Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYEOBht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYEOBht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYEOBhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYEOBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:06 -0400
Message-Id: <20080515013028.056366414@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 21:30:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org
Subject: [PATCH 0/4] Create a CFLAGS_REMOVE for ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently David Miller ported ftrace over to the sparc64. When I mentioned
to him a way to remove the "notrace" from all the functions in some
files done by using a dirty little hack, David (correctly) called it
"Makefile turd" and told us to stop doing that.

I then asked if a CFLAGS_REMOVE_foo.o = -pg would be more pleasing, and he
agreed.

This patch series starts out by creating a CFLAGS_REMOVE_(basetarget).o
that removes options from CFLAGS to compile a target file.

The rest of the patches clean up the Makefile turd with this variant.

Note, I left the turd in the trace directory itself, just because (almost)
all the files there should not be traced. But that's a special directory,
and this patch series keeps the sewage in one place.

-- Steve

