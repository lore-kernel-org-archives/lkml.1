Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbYB0Hj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbYB0Hj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYB0Hjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:39:31 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:40222 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763164AbYB0Hj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:39:29 -0500
Date: Wed, 27 Feb 2008 08:26:42 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Chris Clayton" <chris2553@googlemail.com>
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080227082642.218b8014@morte>
In-Reply-To: <c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	<200802252104.32416.chris2553@googlemail.com>
	<a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	<200802261911.39577.chris2553@googlemail.com>
	<20080226194838.GD3013@tuxdriver.com>
	<c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
	<20080226223814.4ef2b435@morte>
	<c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.1.325704, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.2.26.232251
X-PerlMx-Spam: No virus found, Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_500_599 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 22:36:19 +0000
"Chris Clayton" <chris2553@googlemail.com> wrote:

> 27 135466 rate_change 2 55
> 28 135717 tx_rate 2 55
> 29 135717 tx_status 0 0
> 30 135717 pf_sample 0 3584 1965 0
> 31 135717 rate_change 129 -541505508
> 32 135968 tx_rate 11 540

Known and fixed. The fix isn't in 2.6.25-rc3 yet, though.

Fix:
commit 32720eae675d08990e97bffbf71a31382599cc8a
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Tue Jan 29 20:29:16 2008 +0100

    rc80211-pid: fix rate adjustment


--
Ciao
Stefano
