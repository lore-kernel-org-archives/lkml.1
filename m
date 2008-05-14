Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYENKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYENKHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYENKHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:07:08 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48573 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYENKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:07:06 -0400
Date: Wed, 14 May 2008 13:07:04 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [Bug #10675] ppc compile failure (__flush_icache_range etc
 undeclared)
In-Reply-To: <88YBFoyd1CN.A._DG.Yv1JIB@chimera>
Message-ID: <Pine.SOC.4.64.0805141304570.80@math.ut.ee>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._DG.Yv1JIB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10675
> Subject		: ppc compile failure (__flush_icache_range etc undeclared)
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2008-05-10 11:51 (2 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121042037427529&amp;w=4
> Handled-By	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 		  Segher Boessenkool <segher@kernel.crashing.org>
> Patch		: http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056007.html
> 		  http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056008.html

Patches were merged upstream yesterday and this specific compile error 
does not happen any more.

However, there are 2 page-related link errors, now that it got to 
linking stage:
ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!

Should I report these as different errors or is is related enough?

-- 
Meelis Roos (mroos@linux.ee)
