Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZGBGER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZGBGER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGBGEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:04:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:56774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751678AbZGBGD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:03:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+nc/tJWWWnN8MNDiMcP4YenCqnWCDNjkolnXC2kJ
	sXOj/0H89B0/qh
Subject: [patch 0/4] perf_counter tools: support annotation of live kernel
 modules
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:03:59 +0200
Message-Id: <1246514639.13293.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per $subject, this patch set only supports for the LIVE kernel.  It adds
support infrastructure for path discovery, load address lookup, and
symbol generation  of live kernel modules.

TODO includes resurrection of live annotation in perf top, and support
for annotation and report generation of other than live modules.  As the
patch set sits, Perf top can generate symbols from live binaries, but
there's no live annotation capability yet.

patch1: perf_counter tools: Make symbol loading consistently return number of loaded symbols.
patch2: perf_counter tools: Add infrastructure to support loading of kernel module symbols
patch3: perf_counter tools: connect module support infrastructure to symbol loading infrastructure
patch4: perf_counter tools: Enable kernel module symbol loading in tools

Comments and suggestions most welcome.

	-Mike

