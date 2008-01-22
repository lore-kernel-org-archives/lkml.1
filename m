Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYAVSvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYAVSvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYAVSvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:51:35 -0500
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:41899 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752491AbYAVSve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:51:34 -0500
X-YMail-OSG: 3PjB0jsVM1leh2CqRB_sp4IHyVY7HZZYqq7._qfYfvJdbGaQOwSR9LrG7dTHTRhCww--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.160
Date: Tue, 22 Jan 2008 10:51:33 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, Mike Snitzer <snitzer@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       James.Bottomley@steeleye.com, Jens Axboe <jens.axboe@oracle.com>,
       Milan Broz <mbroz@redhat.com>, Neil Brown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <581071.24701.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: Alasdair G Kergon <agk@redhat.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Mel Gorman <mel@csn.ul.ie>; Fengguang Wu <wfg@mail.ustc.edu.cn>; Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; James.Bottomley@steeleye.com; Jens Axboe <jens.axboe@oracle.com>; Milan Broz <mbroz@redhat.com>; Neil Brown <neilb@suse.de>
> Sent: Tuesday, January 22, 2008 3:39:33 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> 
> See if these patches make any difference:
> 
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
> 
>     dm-md-merge_bvec_fn-with-separate-bdev-and-sector.patch
>     dm-introduce-merge_bvec_fn.patch
>     dm-linear-add-merge.patch
>     dm-table-remove-merge_bvec-sector-restriction.patch
>  


 nope. Exactely the same poor results. To rule out LVM/DM I really have to see what happens if I setup a system with filesystems directly on partitions. Might take some time though.

Cheers
Martin



