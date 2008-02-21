Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbYBUHCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbYBUHCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYBUHCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:02:45 -0500
Received: from mga05.intel.com ([192.55.52.89]:49906 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753771AbYBUHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:02:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,385,1199692800"; 
   d="scan'208";a="522102432"
Message-ID: <1638.172.16.116.56.1203577279.squirrel@linux.intel.com>
Date: Wed, 20 Feb 2008 23:01:19 -0800 (PST)
Subject: kernel-2.6.25-rc2,
      CPU C state "active state" always remain C0 unchangeable by cat 
     'proc/'
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: youquan.song@intel.com
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fedora9 Alpha with  kernel-2.6.25-rc2,
I run " watch -n 0.1 "cat /proc/acpi/processor/CPU*/power | grep 'active
state'" ", I find that the CPU C state information "active state" remain
at "C0" and it do not change any time. The same issue also exit on
2.6.24-rc2 kernel.
But with RHEL5.1 kernel-2.6.18 the CPU C state information is normal.


Every 0.1s: cat /proc/acpi/processor/CPU*/power | grep 'active state'     
                                                                        
Thu Feb 21 09:44:33 2008

active state:            C0
active state:            C0
active state:            C0
active state:            C0
active state:            C0
active state:            C0
active state:            C0
active state:            C0

On RHEL5.1  kernel-2.6.18-53.el5
[root@localhost ~]# cat /proc/acpi/processor/CPU*/power | grep 'active state'
active state:            C2
active state:            C2
active state:            C2
active state:            C2
active state:            C2
active state:            C3
active state:            C2
active state:            C3

The hardware platform: bensley and santarosa.

