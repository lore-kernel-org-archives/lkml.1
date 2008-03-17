Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYCQS4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYCQS4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYCQS4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:56:16 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60661 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622AbYCQS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:56:15 -0400
Message-ID: <47DEBEEA.3060900@davidnewall.com>
Date: Tue, 18 Mar 2008 05:26:42 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <47DE1A4C.9080109@davidnewall.com> <200803170125.28827.phillips@phunq.net>
In-Reply-To: <200803170125.28827.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Monday 17 March 2008 00:14, David Newall wrote:
>   
>> I think you've just tried to obfuscate the truth.  As you have
>> described, replication does not provide full protection against data
>> loss; it loses all changes since last cycle.  Recall that it was you who
>> introduced the word "replication", in the context of guaranteeing no
>> loss of data.
>>     
>
> You are twisting words.

I don't think so.

>   I may have said that replication provides a
> point-in-time copy of a volume, which is exactly what it does, no more,
> no less.
>   

You said that you could achieve a certain performance, and later you
said that for reliability you could use mirroring and replication but
you never said that would lead to a performance hit.  In fact you don't
seem to be able to offer performance AND robustness; for performance you
can only offer that level of robustness attainable on a single system,
which means I think even you agreed was really not up to snuff for
customers who would need the performance that you claim to achieve.

>> You still haven't investigated the benefit of your idea over a whopping
>> great buffer cache.  What's the point in all of this if it turns out, as
>> Alan hinted should be the case, that a big buffer cache gives much the
>> same performance?  You appear to have gone to a great deal of effort
>> without having performed quite simple yet obvious experiments.
>>     
>
> A big buffer cache does not provide a guarantee that the dirty cache
> data saved to disk when line power is lost.
But the filesystem does offer a minimum level of consistency, which is
missing from what you propose.  You propose writing nothing unless
line-power fails.  The big buffer cache gives you all of the robustness
of the underlying filesystem and including dirty buffer writes at some
level greater than zero.


> If you just want to
> explain to me one more time that Linux, batteries, whatever, cannot
> be relied on, then please do not include me in the CC list.

I haven't said that at all, other than as an axiom (which even you have
agreed is fair) leading to comments on the results when something does
fail.  You keep saying that it won't ever fail, then that it will but
that you can mitigate using redundant systems; and then you gloss over
or refuse to face the attendant performance hit.  Finally, you still
have no idea whether your idea really does achieve a massive performance
boost.  You've never compared like amounts of RAM, nor the unsynced
updates that most closely resemble your idea.  In short, you've leaped
on what seems to you to be a good idea and steadfastly refused to
conduct even basic research.  What's the point?

You say don't cc you; I say go away, do that basic research, and come
back when you have hard data.  I really don't think you can ask for
fairer than that.
