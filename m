Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbXGMGrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbXGMGrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXGMGrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:47:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXGMGrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:47:06 -0400
From: Neil Brown <neilb@suse.de>
To: nikola.trajic@telus.net
Date: Fri, 13 Jul 2007 16:47:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18071.8185.249040.492399@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it fixed in 2.6.20 (raid1 spare rebuilding does not resume after raid1 is stopped)
In-Reply-To: message from nikola.trajic@telus.net on Thursday July 12
References: <1184286293.4696c655bccb2@webmail.telus.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 12, nikola.trajic@telus.net wrote:
> 
> 
> [1.] One line summary of the problem:
>  
> raid1 spare rebuilding does not resume after the reboot ( 2.6.18)
>  
> [2.] Full description of the problem/report:
(lots of details, thanks).

I just tried it on 2.6.22-rc6-mm1 (just what I happen to be working
on) and it works fine.  I do have a vague memory of something like
this being fixed in the last several months.
So I suggest that you try a newer kernel.

It could be that commit 1757128438d41670ded8bc3bc735325cc07dc8f9
is the one that fixed this problem, but I cannot be sure.

NeilBrown
