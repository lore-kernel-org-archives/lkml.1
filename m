Return-Path: <linux-kernel-owner+w=401wt.eu-S934980AbXEIAPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbXEIAPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbXEIAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:15:05 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:15650 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933865AbXEIAPD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:15:03 -0400
Date: Wed, 9 May 2007 01:14:59 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Valdis.Kletnieks@vt.edu
Subject: Re: Lockup after logging out of X
Message-ID: <20070509001459.GA2435@deepthought>
References: <20070508195142.GA30030@deepthought> <20070508230134.GD17482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070508230134.GD17482@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:01:34AM +0200, Andi Kleen wrote:
> 
> Already known, although it is still unclear what the bug actually is.
> Can you run with the appended patch please (from Eric Biederman) 
> and post any backtraces the WARN_ON in there spews out? 
> 
> Also do you use swiotlb?
> 
> Thanks
> 
> -Andi
> 
 Had to turn off modules to get it to build.  It half-logged another
oops, but no backtraces, and SysRq+r does nothing.  Nothing else
unusual in the log.

May  9 00:47:12 bluesbreaker gconfd (ken-2833): Resolved address
"xml:readonly:/etc/gnome/gconf/gconf.xml.defaults" to a read-only
configuration source at position 2
May  9 00:52:59 bluesbreaker kernel: [  275.667737] Unable to handle
kernel paging request at ffff81003b4ac3e8 RIP:
May  9 00:52:59 bluesbreaker kernel: [  275.667742]
[<ffffffff8027134a>] fasync_helper+0x52/0xf0
May  9 00:52:59 bluesbreaker kernel: [  275.667749] PGD 8063 PUD
9063 PMD 800000003b4a11e3 BAD
May  9 00:52:59 bluesbreaker kernel: [  275.667754] Oops: 0009 [1]
PREEMPT
May  9 00:54:26 bluesbreaker syslogd 1.4.1: restart.
May  9 00:54:26 bluesbreaker bootlog: Starting system log daemon...
[  OK  ]

 Apparently I do use swiotlb - I didn't know that, and can't see
where it gets asked in menuconfig, but I can see
CONFIG_SWIOTLB=y

 Let me know if there is anything else I can test (probably pm
tomorrow), otherwise I'll go back to -head.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
