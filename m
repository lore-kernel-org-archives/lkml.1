Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYANBlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYANBlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYANBls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:41:48 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46386 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYANBlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:41:47 -0500
Date: Sun, 13 Jan 2008 20:41:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: apw@shadowen.org
cc: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: EXPORTS_SYMBOLs that are in assembly?
Message-ID: <Pine.LNX.4.58.0801132038410.1764@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi guys,

Just wondering what the proper way to export a symbol that is defined in
assembly? Or is there some kind of annotation I can add in comment form
that will let checkpatch know the variable is not in C?

Here's what I'm getting:

./scripts/checkpatch.pl patches/`quilt top`
WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable
#197: FILE: lib/tracing/mcount.c:42:
+EXPORT_SYMBOL_GPL(mcount);

total: 0 errors, 1 warnings, 316 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks,

-- Steve

