Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXEJSUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXEJSUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXEJSU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:20:28 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:15984 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbXEJSU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:20:28 -0400
X-IronPort-AV: i="4.14,518,1170662400"; 
   d="scan'208"; a="771881659:sNHT42655282"
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Roland Dreier" <rolandd@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: trivial MLX4_DEBUG dependency fix.
X-Message-Flag: Warning: May contain useful information
References: <20070510035028.GA26453@linux-sh.org> <aday7jw29ci.fsf@cisco.com>
	<a781481a0705100511l1bfdc7f3tc2669eb916f76594@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 10 May 2007 11:20:14 -0700
In-Reply-To: <a781481a0705100511l1bfdc7f3tc2669eb916f76594@mail.gmail.com> (Satyam Sharma's message of "Thu, 10 May 2007 17:41:21 +0530")
Message-ID: <ada8xbw1qxt.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 May 2007 18:20:15.0058 (UTC) FILETIME=[DB043320:01C7932F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > IMHO default configs must be aimed at production usage scenarios, so
 > are better off without debugging enabled by default. Except if the
 > driver is really new / EXPERIMENTAL where the goal is to get it tested
 > out by all users asap (and no production systems would be using it
 > anyway).

I agree, but I would hope that MLX4_DEBUG *is* enabled in production.
It doesn't print anything or introduce any measurable overhead except
for slightly larger code size unless the debug level is explicitly
increased, so the only reason to turn it off is if a few bytes of code
makes a big difference to you (hence making it selectable only if
EMBEDDED is selected).
