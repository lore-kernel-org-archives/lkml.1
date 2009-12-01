Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZLASbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZLASbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZLASbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:31:37 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:30569 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZLASbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:31:36 -0500
Message-ID: <4B1560C2.8040603@oracle.com>
Date: Tue, 01 Dec 2009 10:30:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: percpu error in linux-next (CONFIG_SMP=n)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B1560E1.0175:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Tejun,

drivers/base/cpu.c: line 100: fails to build when CONFIG_SMP=n:

	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));

Can you suggest a fix for that, please?

thanks,
-- 
~Randy
