Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXJTBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXJTBSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXJTBSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:18:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34917 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXJTBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:18:30 -0400
Message-ID: <47195763.1090803@ct.jp.nec.com>
Date: Fri, 19 Oct 2007 18:18:27 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com, hbabu@us.ibm.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 0/3] x86: unify crash_32/64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I made patches to unify crash_32/64.c.
There are three patches;
1. add lapic_shutdown for x86_64
2. add safe_smp_processor_id for x86_64
3. unify crash_32/64.c

I'm not sure that it's good to split to these patches.

I've compiled on both of 32bit and 64bit, and tested
kdump on 64bit.

Thanks
Hiroshi Shimamoto
