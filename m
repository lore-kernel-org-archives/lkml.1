Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbXGJRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbXGJRhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXGJRh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:37:26 -0400
Received: from dvhart.com ([64.146.134.43]:59148 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbXGJRh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:37:26 -0400
Message-ID: <4693C3D2.9020005@mbligh.org>
Date: Tue, 10 Jul 2007 10:37:22 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Performance regression in 2.6.22-git1 (new sched code?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

~ 1% on 4-way x86_64

http://test.kernel.org/perf/kernbench.elm3b6.png

~ 4% on 16-way NUMA-Q (i386)

http://test.kernel.org/perf/kernbench.moe.png

~ 1.5% on 4-way i386

http://test.kernel.org/perf/kernbench.elm3b132.png

There's readprofiles and stuff available from here:
http://test.kernel.org/functional/index.html
if you drill down under the tests marked "regression", eg.
http://test.kernel.org/abat/98796/002.kernbench.test/profiling/profile.text

M.
