Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYAVXmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYAVXmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYAVXmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:42:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYAVXmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:42:09 -0500
Date: Tue, 22 Jan 2008 23:40:52 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, Mike Snitzer <snitzer@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       James.Bottomley@steeleye.com, Jens Axboe <jens.axboe@oracle.com>,
       Milan Broz <mbroz@redhat.com>, Neil Brown <neilb@suse.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Message-ID: <20080122234051.GP8075@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Martin Knoblauch <spamtrap@knobisoft.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com, Jens Axboe <jens.axboe@oracle.com>,
	Milan Broz <mbroz@redhat.com>, Neil Brown <neilb@suse.de>
References: <87924.1242.qm@web32614.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87924.1242.qm@web32614.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 07:25:15AM -0800, Martin Knoblauch wrote:
>   [root@lpsdm52 ~]# dmsetup table
> VolGroup00-LogVol02: 0 350945280 linear 104:2 67109248
> VolGroup00-LogVol01: 0 8388608 linear 104:2 418054528
> VolGroup00-LogVol00: 0 67108864 linear 104:2 384

The IO should pass straight through simple linear targets like that without
needing to get broken up, so I wouldn't expect those patches to make any
difference in this particular case.

Alasdair
-- 
agk@redhat.com
