Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYCPFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYCPFmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 01:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYCPFmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 01:42:11 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60371 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbYCPFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 01:42:11 -0400
Message-ID: <47DCB347.2060706@davidnewall.com>
Date: Sun, 16 Mar 2008 16:12:31 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803131214.40321.phillips@phunq.net> <20080315205950.GA13012@1wt.eu> <200803151417.13899.phillips@phunq.net>
In-Reply-To: <200803151417.13899.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
>> Also, please note that the problem here is not related to the number of
>> nines of availability. This number only counts the ratio between uptime
>> and downtime. We're more facing a problem of MTBF, where the consequences
>> of a failure are hard to predict.
>>     
>
> That is why I keep recommending that a ramback setup be replicated or
> mirrored, which people in this thread keep glossing over.  When
> replicated or mirrored, you still get the microsecond-level transaction
> times, and you get the safety too.

Do you mean it should be replicated with a second ramback?  That would
be pretty pointless, since all failure modes would affect both.  It's
not like one ramback will survive a crash when the other doesn't.
