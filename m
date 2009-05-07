Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZEGFVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZEGFVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 01:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZEGFVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 01:21:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZEGFVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 01:21:01 -0400
From: Neil Brown <neilb@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Date: Thu, 7 May 2009 15:21:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18946.28620.916415.205482@notabene.brown>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] md: Avoid to call flush_scheduled_work() with BKL
	held
In-Reply-To: message from Ingo Molnar on Sunday April 26
References: <1240492313-6560-1-git-send-email-abogani@texware.it>
	<20090426163841.GC6236@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 26, mingo@elte.hu wrote:
> 
> Hm, couldnt we switch the ioctl in drivers/md/md.c from 
> ->locked_ioctl to ->unlocked_ioctl?
> 
> Neil, what do you think?

Yes, definitely.  Though it is just 'ioctl', not 'unlocked_ioctl'.

I'll queue a patch for 2.6.31.

NeilBrown
