Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYFSHep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYFSHep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYFSHeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:34:37 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20658 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754585AbYFSHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:34:36 -0400
Message-ID: <485A0BE8.7020306@panasas.com>
Date: Thu, 19 Jun 2008 10:34:00 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
 drivers
References: <1213802866.3515.24.camel@localhost.localdomain> <4859461A.7060003@panasas.com> <alpine.LNX.1.10.0806190117090.4593@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0806190117090.4593@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2008 07:34:03.0042 (UTC) FILETIME=[D8CE9020:01C8D1DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 19, 2008, 2:20 +0300, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 18 Jun 2008, Benny Halevy wrote:
> 
>> Exposing the not-yet-ready-to-be-released code to linux-next will expose 
>> conflicts earlier, and hopefully in smaller, more manageable deltas.
> 
> I like the way linux-next works now, i.e. it should reflect what is going 
> into the next major kernel release. Nothing more, nothing less.
> 
> Also, when talking about entirely new drivers for hardware that hasn't 
> been supported by the kernel at all so far (this is the situation we are 
> talking about, right?), there shouldn't be a lot of conflicts to be dealt 
> with, right? Ideally, drivers should be pretty isolated standalone pieces 
> of code that don't have any business changing any code that has been 
> already there.
> 

The showcase example I have in mind is our OSD initiator for which
we pushed all dependencies already upstream, so currently it has
no conflicts with the existing code.  However, it is not ready
for the next release since it should be reviewed, documented,
and accepted by the sub-system maintainer first.

I would like it to be included in linux-next so to be alerted of any
arising conflict so I can fix it in "real time" rather than waiting
for the next release to come out.  Initially I thought it'd be a good
candidate for linux-staging, but Greg doesn't quite agree with that
(http://lkml.org/lkml/2008/6/11/225) since it's destined for linux-scsi.
Hence, a -staging branch/tree based off of James' tree makes sense.

Benny

