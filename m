Return-Path: <linux-kernel-owner+w=401wt.eu-S1763146AbYARUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146AbYARUfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbYARUfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:35:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33280 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbYARUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:35:23 -0500
Message-ID: <47910D6E.3070801@garzik.org>
Date: Fri, 18 Jan 2008 15:34:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ric@emc.com
CC: Theodore Tso <tytso@mit.edu>, Bryan Henderson <hbryan@us.ibm.com>,
       Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Daniel Phillips <phillips@google.com>,
       Rik van Riel <riel@redhat.com>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
References: <478FE22D.9030907@emc.com> <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com> <20080118142308.GD12796@mit.edu> <4790C50F.2080704@emc.com>
In-Reply-To: <4790C50F.2080704@emc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Theodore Tso wrote:
>> On Thu, Jan 17, 2008 at 04:31:48PM -0800, Bryan Henderson wrote:
>>> But I heard some years ago from a disk drive engineer that that is a 
>>> myth just like the rotational energy thing.  I added that to the 
>>> discussion, but admitted that I haven't actually seen a disk drive 
>>> write a partial sector.
>>
>> Well, it would be impossible or at least very hard to see that in
>> practice, right?  My understanding is that drives do sector-level
>> checksums, so if there was a partially written sector, the checksum
>> would be bogus and the drive would return an error when you tried to
>> read from it.
> 
> There is extensive per sector error correction on each sector written. 
> What you would see in this case (or many, many other possible ways 
> drives can corrupt media) is a "media error" on the next read.

Correct.


> You would never get back the partially written contents of that sector 
> at the host.

Correct.


> Having our tools (fsck especially) be resilient in the face of media 
> errors is really critical. Although I don't think the scenario of a 
> partially written sector is common, media errors in general are common 
> and can develop over time.

Agreed.

	Jeff



