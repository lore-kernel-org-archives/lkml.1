Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYKVEWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYKVEWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 23:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYKVEWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 23:22:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:27156 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYKVEWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 23:22:32 -0500
Date: Fri, 21 Nov 2008 20:22:32 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: h-shimamoto@ct.jp.nec.com
Subject: [PATCH 0/3 v2] softirq: Statistics for softirq
Message-Id: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of statistics for softirq patch series.
Thanks to Andrew for comments!
These patches are fixed about the following.

Against: next-20081121

Change Log v1 -> v2
[2/3] ...  proc: Export statistics for softirq to /proc
o Change from for_each_online_cpu() to for_each_possible_cpu()
  in show_softirqs().
o Make "proc_softirqs_operations" const.
o Don't introduce for_each_softirq_nr() for readability.
