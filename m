Return-Path: <linux-kernel-owner+w=401wt.eu-S934748AbZLQWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748AbZLQWOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbZLQWOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:14:19 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:33238 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbZLQWOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:14:18 -0500
Date: Thu, 17 Dec 2009 14:13:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: <eduard.munteanu@linux360.ro>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmemtrace.txt question: kernel parameter(s)?
Message-Id: <20091217141342.9ae2072b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B2AAD24.029A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Documentation/trace/kmemtrace.txt says:

Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
this? Should I worry?
A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
large the number is. You can fix it by supplying a higher
'kmemtrace.subbufs=N' kernel parameter.


Where is this kernel parameter implemented and where is it documented?
or should this Answer just be fixed?


thanks,
---
~Randy
