Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYCQI0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYCQI0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYCQIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:25:48 -0400
Received: from phunq.net ([64.81.85.152]:38547 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754234AbYCQIZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:25:46 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 17 Mar 2008 00:25:27 -0800
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <47DE1A4C.9080109@davidnewall.com>
In-Reply-To: <47DE1A4C.9080109@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170125.28827.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 00:14, David Newall wrote:
> >> if you are depending on replication over the network you have just limited 
> >> your throughput to your network speed and latency.
> >
> > Replication does not work that way.  On each replication cycle, the
> > differences between the most recent two volume snapshots go over the
> > network. [...]
> > Mirroring on the other hand, makes a realtime copy of a volume, that is
> > never out of date.
> 
> I think you've just tried to obfuscate the truth.  As you have
> described, replication does not provide full protection against data
> loss; it loses all changes since last cycle.  Recall that it was you who
> introduced the word "replication", in the context of guaranteeing no
> loss of data.

You are twisting words.  I may have said that replication provides a
point-in-time copy of a volume, which is exactly what it does, no more,
no less.

> You still haven't investigated the benefit of your idea over a whopping
> great buffer cache.  What's the point in all of this if it turns out, as
> Alan hinted should be the case, that a big buffer cache gives much the
> same performance?  You appear to have gone to a great deal of effort
> without having performed quite simple yet obvious experiments.

A big buffer cache does not provide a guarantee that the dirty cache
data saved to disk when line power is lost.  If you would like to
add that feature to the Linux buffer cache, then please do it, or make
whichever other contribution you wish to make.  If you just want to
explain to me one more time that Linux, batteries, whatever, cannot
be relied on, then please do not include me in the CC list.

Daniel
