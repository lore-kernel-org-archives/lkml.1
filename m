Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbXIPHjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbXIPHjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXIPHjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:39:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34427 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXIPHjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:39:13 -0400
Message-ID: <46ECDDA0.3070701@garzik.org>
Date: Sun, 16 Sep 2007 03:39:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jumbo all-NICs ethtool count cleanup
References: <20070916061015.GA11373@havoc.gtf.org> <20070916062722.GA5498@uranus.ravnborg.org>
In-Reply-To: <20070916062722.GA5498@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi Jeff.
> 
> You wrote:
>> The hooks ->self_test_count() and ->get_stats_count() are now unused
>> in the main tree.
> 
> So I'm suprised to see more lines added than deleted:
>>  35 files changed, 346 insertions(+), 246 deletions(-)
> 
> Puzzled - may need a bit more coffee (morning here)..

The new interface that supercedes these is ->get_sset_count(), which was 
added to provide additional functionality without having to add a new 
hook each time we want to return a new integer value.  This new 
interface also (intentionally) aligns with the existing ->get_strings() 
interface.  ("sset" in get_sset_count stands for "string set")

	Jeff



