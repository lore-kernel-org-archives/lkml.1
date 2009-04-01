Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbZDAOZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbZDAOZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765852AbZDAOZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:25:43 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:49487 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbZDAOZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:25:42 -0400
Date: Wed, 1 Apr 2009 17:25:40 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange MTRR on 2.6.29-git
In-Reply-To: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
Message-ID: <Pine.SOC.4.64.0904011722350.14173@math.ut.ee>
References: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Found this on todays 2.6.29 + git. The same address range has both WB 
> and UC MTRR-s.
> 
> reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
> reg01: base=0x020000000 (  512MB), size=    1MB, count=1: write-back
> reg02: base=0x020000000 (  512MB), size=    1MB, count=1: uncachable
> reg03: base=0x0f2000000 ( 3872MB), size=   32MB, count=2: write-combining
> reg04: base=0x0f8000000 ( 3968MB), size=   64MB, count=1: write-combining

Actually, these double MTRR-s for the range @ 512M are there long time. 
Testbooted 2.6.20 that is the earliest kernel I have around here and 
this conflicting double MTRR is still there, so it's not a recent 
change. In 2.6.20 reg04 was not present but that's probably unimportant 
since reg01 and reg02 are the same.

-- 
Meelis Roos (mroos@linux.ee)
