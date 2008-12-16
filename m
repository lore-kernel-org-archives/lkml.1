Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYLPFNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYLPFNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYLPFNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:13:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbYLPFNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:13:36 -0500
Message-ID: <4947389D.1050708@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 13:11:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Why are the pages not migrated to current cpuset after 'memory_migrate'
 is set true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

I found the pages that task had allocated to it on nodes in its previous cpuset
were not migrated to the tasks' current cpuset after 'memory_migrate' was set
true. It looks strange for users. Why are the pages not migrated to current
cpuset after 'memory_migrate' is set true?

Step I did
1, allocate pages on cpuset (mems is 0, memory_migrate is 0)
2, change cpuset's mems (mems: 0 -> 1)
3, change cpuset's memory_migrate(memory_migrate: 0 -> 1) 
 
Regards
Miao Xie

