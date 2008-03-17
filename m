Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYCQLSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYCQLSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYCQLS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:18:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYCQLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:18:27 -0400
Date: Mon, 17 Mar 2008 20:18:43 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Fenghua Yu <fenghua.yu@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tested following.

 % ./hackbench 130 process 500

 (this parameter mean consume all physical memory and 1G swap space)


2.6.25-rc3-mm1: works well
2.6.25-rc5:     works well
2.6.25-rc5-mm1: doesn't finish >12 hour 

my bisect indicate the cause of bug is git-ia64.patch.
and, git-ia64.patch of 2.6.25-rc5-mm1 contain following patches.

    [IA64] cleanup and improve fsys_gettimeofday
    [IA64] Multiple outstanding ptc.g instruction support
    [IA64] VIRT_CPU_ACCOUNTING (accurate cpu time accounting)


unfortunately, I don't know how investigate more ;-)
Please any suggestion.





