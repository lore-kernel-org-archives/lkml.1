Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYB0QE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYB0QE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbYB0QEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:04:15 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3247 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbYB0QEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:04:13 -0500
Date: Wed, 27 Feb 2008 10:51:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Chris Clayton <chris2553@googlemail.com>, ivdoorn@gmail.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080227155111.GB3078@tuxdriver.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802252104.32416.chris2553@googlemail.com> <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com> <200802261911.39577.chris2553@googlemail.com> <20080226194838.GD3013@tuxdriver.com> <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com> <20080226223814.4ef2b435@morte> <c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com> <20080227082642.218b8014@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227082642.218b8014@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 08:26:42AM +0100, Stefano Brivio wrote:
> On Tue, 26 Feb 2008 22:36:19 +0000
> "Chris Clayton" <chris2553@googlemail.com> wrote:
> 
> > 27 135466 rate_change 2 55
> > 28 135717 tx_rate 2 55
> > 29 135717 tx_status 0 0
> > 30 135717 pf_sample 0 3584 1965 0
> > 31 135717 rate_change 129 -541505508
> > 32 135968 tx_rate 11 540
> 
> Known and fixed. The fix isn't in 2.6.25-rc3 yet, though.
> 
> Fix:
> commit 32720eae675d08990e97bffbf71a31382599cc8a
> Author: Stefano Brivio <stefano.brivio@polimi.it>
> Date:   Tue Jan 29 20:29:16 2008 +0100
> 
>     rc80211-pid: fix rate adjustment

And it currently isn't queued for 2.6.25 at all.

Chris, can you cherry-pick this from the wireless-2.6.26 tree and
give it a test on your 2.6.25-rc3 tree?  If it resolves a problem
then I'll queue it to Dave for 2.6.25 (which will probably provoke
a net-2.6.26 and wireless-2.6.26 rebase).

Let me know...

John
-- 
John W. Linville
linville@tuxdriver.com
