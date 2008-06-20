Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYFTOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYFTOiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYFTOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:38:16 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:40797 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYFTOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:38:15 -0400
X-IronPort-AV: E=Sophos;i="4.27,679,1204531200"; 
   d="scan'208";a="42893125"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Eli Cohen <eli@dev.mellanox.co.il>, general@lists.openfabrics.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: wait_for_completion_timeout() spurious failure under heavy load?
References: <ada63s5w088.fsf@cisco.com> <485B50F1.2020802@gmail.com>
	<20080620112042.GE7439@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 20 Jun 2008 07:33:02 -0700
In-Reply-To: <20080620112042.GE7439@elte.hu> (Ingo Molnar's message of "Fri,
	20 Jun 2008 13:20:42 +0200")
Message-ID: <adahcbotbvl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jun 2008 14:33:02.0844 (UTC) FILETIME=[8BB5ABC0:01C8D2E2]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > but like in the commit below. Agreed?

 > +
 > +			/*
 > +			 * If the completion has arrived meanwhile
 > +			 * then return 1 jiffy time left:
 > +			 */
 > +			if (x->done && !timeout) {
 > +				timeout = 1;
 > +				break;
 > +			}
 > +

Sure, that looks nice to me.

 - R.
