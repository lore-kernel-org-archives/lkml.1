Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYGYSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYGYSWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYGYSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:22:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29343 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYGYSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:22:14 -0400
Date: Fri, 25 Jul 2008 11:21:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: pj@sgi.com, menage@google.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: cpuset build error: cpuset_mems_nr() missing
Message-Id: <20080725112146.1cf70319.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When SYSCTL=n, PROC_FS=n:

linux-next-20080725/mm/hugetlb.c:1507: error: implicit declaration of function 'cpuset_mems_nr'
make[2]: *** [mm/hugetlb.o] Error 1


Alan mentioned this in another mail thread and I believe he said that the problem
is also in mainline... but I haven't checked that.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
