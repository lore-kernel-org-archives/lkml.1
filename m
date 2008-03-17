Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYCQIQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYCQIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYCQIQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:16:49 -0400
Received: from phunq.net ([64.81.85.152]:60284 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752649AbYCQIQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:16:49 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 17 Mar 2008 00:16:18 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170116.19546.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 23:49, david@lang.hm wrote:
> > Mirroring on the other hand, makes a realtime copy of a volume, that is
> > never out of date.
> 
> so just mirror to a local disk array then.

Great idea.  Except that the disk array has millisecond level latency,
when what we trying to achieve is microsecond level latency.

> a local disk array has more write bandwidth than a network connection to a 
> remote machine, so if you can mirror to a remote machine you can mirror to 
> a local disk array.

So you could potentially connect to a _huge_ disk array and write deltas
to it.  The disk array would have to support roughly 3 Gbytes/second of
write bandwidth to keep up with the Violin ramdisk.  Doable, but you are
now in the serious heavy iron zone.

Personally, I like my nice simple design a lot more.  Just mirror it, as
many times as you need to satisfy your paranoia.  Or how about go write
your own?

Daniel
