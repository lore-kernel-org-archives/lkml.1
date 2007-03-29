Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXC2GZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXC2GZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 02:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXC2GZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 02:25:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:39766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbXC2GZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 02:25:17 -0400
From: Neil Brown <neilb@suse.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Thu, 29 Mar 2007 16:25:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17931.23488.160031.119117@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
In-Reply-To: message from Justin Piszcz on Tuesday March 27
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday March 27, jpiszcz@lucidpixels.com wrote:
> I ran a check on my SW RAID devices this morning.  However, when I did so, 
> I had a few lftp sessions open pulling files.  After I executed the check, 
> the lftp processes entered 'D' state and I could do 'nothing' in the 
> process until the check finished.  Is this normal?  Should a check block 
> all I/O to the device and put the processes writing to a particular device 
> in 'D' state until it is finished?

No, that shouldn't happen.  The 'check' should notice any other disk
activity and slow down if anything else is happening on the device.

Did the check run to completion?  And if so, did the 'lftp' start
working normally again?

Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
running at?

NeilBrown
