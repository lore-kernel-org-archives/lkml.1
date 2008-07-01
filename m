Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbYGAAQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbYGAAQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYGAAPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:15:53 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33286 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYGAAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:15:52 -0400
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="120661930"
From: Roland Dreier <rdreier@cisco.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: general@lists.openfabrics.org, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [ofa-general] Re: [PATCH] IB/uverbs: BKL is not needed for ib_uverbs_open()
References: <20080627095418.2353267d@bike.lwn.net> <adaskuylfk7.fsf@cisco.com>
	<20080630165543.1ccd8858@bike.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 30 Jun 2008 17:15:51 -0700
In-Reply-To: <20080630165543.1ccd8858@bike.lwn.net> (Jonathan Corbet's message
	of "Mon, 30 Jun 2008 16:55:43 -0600")
Message-ID: <adaprpyfoi0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 00:15:51.0452 (UTC) FILETIME=[9EC14DC0:01C8DB0F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > That's the general idea: audit the code where the BKL appears and
 > remove it when it's safe to do so.  It's always an appropriate time;
 > the only question is whether you think this change is good to go into
 > the tree for 2.6.27, or whether it should hang out in linux-next for
 > one more cycle.  I would assume that the extra time would not be
 > necessary.

Yes, this change should be good to go for 2.6.27.

Thanks,
  Roland
