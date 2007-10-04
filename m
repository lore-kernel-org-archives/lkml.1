Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXJDUxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXJDUxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXJDUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:53:28 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:61641 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbXJDUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:53:27 -0400
X-IronPort-AV: E=Sophos;i="4.21,232,1188802800"; 
   d="scan'208";a="21674930"
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: Vague maybe ppp-related panic report for 2.6.23-rc9
X-Message-Flag: Warning: May contain useful information
References: <ada4ph6da05.fsf@cisco.com>
	<20071004.135113.48807663.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 04 Oct 2007 13:53:25 -0700
In-Reply-To: <20071004.135113.48807663.davem@davemloft.net> (David Miller's message of "Thu, 04 Oct 2007 13:51:13 -0700 (PDT)")
Message-ID: <adahcl6bnzu.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Oct 2007 20:53:25.0721 (UTC) FILETIME=[9BCD5490:01C806C8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I don't want to jump the gun on the analysis but it just might
 > be the packet sharing fixes Herbert put in a short time ago.
 > 
 > What you could do is go back to say rc2 and see if you still get
 > the panics, then bisect from there to narrow it down.
 > 
 > If rc2 still gives the panic, it's something else, perhaps device
 > specific.

OK thanks.  I'm still trying to find a good way to reproduce it, so
I'm going to try to get it to happen with -rc9 while running in the
console, and at least take a picture of the backtrace.  If I find a
good way to make it happen then I'll try rc2 and let you know.

 - R.
