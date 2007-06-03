Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbXFCMha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbXFCMha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXFCMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:37:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34959 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXFCMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:37:23 -0400
Date: Sun, 3 Jun 2007 14:35:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
In-Reply-To: <200706031146.l53BkuaZ011945@toshiba.co.jp>
Message-ID: <Pine.LNX.4.61.0706031434530.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr> <200706031146.l53BkuaZ011945@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>From: Jan Engelhardt <jengelh@linux01.gwdg.de>
>Date: Sun, 3 Jun 2007 13:12:55 +0200 (MEST)
>
>> +static int __init xt_connlimit_init(void)
>> +{
>> +	need_conntrack_ipv4();
>> +	return xt_register_match(&xt_connlimit_reg);
>> +}
>
>You can use nf_ct_l3proto_try_module_get() instead of introducing
>need_conntrack_ipv4(). Please refer xt_state.c and xt_conntrack.c as
>example.

Thank you for this hint. I will add it and post updates versions
of the patch(es) when I am done with all.


Thanks,
	Jan
-- 
