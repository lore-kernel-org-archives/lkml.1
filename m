Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbYF3NNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbYF3NNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYF3NNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:13:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYF3NNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Rk+BtMG/DjlKGlSkDw/6EAIRMQcuW9lrKTlqYjk9Jxr/oQww8jaJdmr57J5kU4BfaP
         A9svJBosr6vEud3bNKq/daWjGeDBrzXCsTj9vUNcMf+mEuIRNTAjPTUl+74hFrhxszuI
         MBK+eymqgugcAMC1KxYLIhEhuKvqgGWBk622A=
To: linux-kernel@vger.kernel.org
Subject: [patch 00/19] perfmon2 minimal v3:  introduction
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:26 -0700 (PDT)
Message-ID: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches implement a minimal perfmon2 subsystem which provides
access to the hardware performance counters of modern processors. Performance
counters are very useful resource to extract micro-architectural-level information
such the number of caches misses, or the number of instructions executed. The list
of events which can be monitored in highly specific to each processor implmentation.

This series supports ONLY per-thread counting of PMU events (no sampling) for
AMD64 and Intel processors with support for architectural perfmon (Core Duo/Solo,
Core 2) in both 32 and 64 bit modes.

This is version 3 of the series. It is against Stephen Rothwell linux-next GIT
tree. Compared to the previous version, there were a few more cleanups in the
Makefile structure suggested by Stephen. The series also merges more code
between 32 and 64 bit x86.

Please review.

More information about the perfmon2 project can be found at:

		http://perfmon2.sourceforge.net

To test this series, it is possible to use libpfm and pfmon, both
available from the web site above.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

-- 

