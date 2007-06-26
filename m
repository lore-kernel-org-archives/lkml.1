Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbXFZH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbXFZH5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 03:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXFZH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 03:57:27 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:44404 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 03:57:27 -0400
Message-ID: <4680C6F3.9000504@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 15:57:39 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bugs in __schedule()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 07:57:22.0451 (UTC) FILETIME=[A09F2E30:01C7B7C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody has suggestions on this crash?

[c02dc4dc] __schedule+0x654/0x788
 [c02dc6f4] schedule+0x4c/0xe4
 [c02dbe24] __compat_down+0xc8/0x12c
 [c0226b60] mv_sw_read_reg+0x178/0x17c
 [c02296fc] mvSwIntrTasklet+0x128/0x744
 [c0020afc] tasklet_action+0x7c/0xec
 [c00204f4] ___do_softirq+0x80/0x11c
 [c00205cc] __do_softirq+0x3c/0x6c
 [c00206a4] do_softirq+0x60/0x68
 [c00207a8] irq_exit+0x6c/0x94
 [c0005e1c] do_IRQ+0x88/0xa4
 [c0004b70] ret_from_except+0x0/0x18
 [c000680c] __delay+0xc/0x14
 [c0226598] mv_sw_read_smi_reg+0x84/0x1ac

Thanks,
Gavin
 [c0226adc] mv_sw_read_reg+0xf4/0x17c


