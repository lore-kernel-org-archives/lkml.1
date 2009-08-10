Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbZHJRmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbZHJRmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbZHJRmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:42:22 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16042 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbZHJRmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:42:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABT5f0qrR7PE/2dsb2JhbAC5eogrjnQFhBg
X-IronPort-AV: E=Sophos;i="4.43,354,1246838400"; 
   d="scan'208";a="364362643"
From: Roland Dreier <rdreier@cisco.com>
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: general@lists.openfabrics.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] Re: [PATCH 10/14] infiniband: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	<1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com>
	<adaocqo9sb4.fsf@cisco.com>
	<200908100936.26963.jackm@dev.mellanox.co.il>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Aug 2009 10:42:18 -0700
In-Reply-To: <200908100936.26963.jackm@dev.mellanox.co.il> (Jack Morgenstein's
	message of "Mon, 10 Aug 2009 09:36:26 +0300")
Message-ID: <ada7hxba7lx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Aug 2009 17:42:18.0321 (UTC) FILETIME=[E7F1F410:01CA19E1]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I'm a bit nervous about this one.  
 > printk_once will print once ONLY if CONFIG_PRINTK is set in include/linux/autoconf.h
 > (i.e., when the kernel is configured).  Otherwise, it gets defined to printk --
 > and it will always print in this case.
 > (see 2.6.30.xx kernel include file "include/linux/kernel.h", lines 235, 249, and 272).

Umm... if CONFIG_PRINTK is turned off nothing prints, right?

 > Do you think that distributions will ALWAYS have CONFIG_PRINTK defined?

Yes, I suspect they do want to get kernel messages.

 - R.
