Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYCMGan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYCMGan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYCMGad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:30:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:59110 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYCMGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:30:32 -0400
Date: Wed, 12 Mar 2008 23:32:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803122317.24849.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803122327260.3786@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803121556.15547.phillips@phunq.net> <47D8BF76.8040105@davidnewall.com> <200803122317.24849.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Daniel Phillips wrote:

> On Wednesday 12 March 2008 22:45, David Newall wrote:
>
>> Your idea seems predicated on throwing large amounts of RAM at the
>> problem.  What I want to know is this: Is it really 25 times faster than
>> ext3 with an equally huge buffer cache?
>
> Yes.

this I don't understand. what makes your approach 25x faster?

looking at the comparison of a 500G filesystem with 500G of ram allocated 
for a buffer cache.

yes, initially it will be a bit slower (until the files get into the 
buffer cache), and if fsync is disabled all writes will go to the buffer 
cache (until writeout hits)

I may be able to see room for a few percent difference, but not 2x, let 
alone 25x.

David Lang
