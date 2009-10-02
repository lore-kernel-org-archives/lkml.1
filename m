Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZJBPDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZJBPDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZJBPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:03:29 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:56728 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbZJBPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:03:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Trevor Hemsley <trevor.hemsley@ntlworld.com>
Subject: Re: Temperature above threshold loop with 2.6.31.1
Date: Fri, 2 Oct 2009 17:03:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20091002134430.SOPU22934.aamtaout04-winn.ispmail.ntl.com@trevor2.dsl.pipex.com>
In-reply-To: <20091002134430.SOPU22934.aamtaout04-winn.ispmail.ntl.com@trevor2.dsl.pipex.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021703.31679.elendil@planet.nl>
X-OriginalArrivalTime: 02 Oct 2009 15:03:32.0746 (UTC) FILETIME=[82274EA0:01CA4371]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trevor Hemsley wrote:
> I just downloaded and installed the latest 2.6.31.1 kernel on my
> machine here and I think I found a small bug. Shortly after boot I
> start to receive messages like
> 
> CPU0: Temperature above threshold, cpu clock throttled (total events =
> 21672)
[...] 
> More importantly, I get approximately 100,000 of these messages per
> minute and the machine is completely unusable. All of these are for
> CPU0 - at least all the ones that get written to /var/log/messages.
> 
> 1,666 notifications a second seems a little on the 'too frequent' side
> of things to me :-)

Looks like this may already be fixed in mainline by the following commit:
commit b417c9fd8690637f0c91479435ab3e2bf450c038
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Sep 22 15:50:24 2009 +0200
    x86: mce: Fix thermal throttling message storm

Can you confirm that please, either by compiling current git or by applying 
that commit on top of 2.6.31.1?

Ingo: is that patch already scheduled for stable?

Cheers,
FJP
