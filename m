Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYARPct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYARPct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYARPck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:32:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbYARPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:32:39 -0500
Message-ID: <4790C0EE.10207@zytor.com>
Date: Fri, 18 Jan 2008 10:08:30 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bryan Henderson <hbryan@us.ibm.com>
CC: Ric Wheeler <ric@emc.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Daniel Phillips <phillips@google.com>, Rik van Riel <riel@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
References: <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com>
In-Reply-To: <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
> 
> We weren't actually talking about writing out the cache.  While that was 
> part of an earlier thread which ultimately conceded that disk drives most 
> probably do not use the spinning disk energy to write out the cache, the 
> claim was then made that the drive at least survives long enough to finish 
> writing the sector it was writing, thereby maintaining the integrity of 
> the data at the drive level.  People often say that a disk drive 
> guarantees atomic writes at the sector level even in the face of a power 
> failure.
> 
> But I heard some years ago from a disk drive engineer that that is a myth 
> just like the rotational energy thing.  I added that to the discussion, 
> but admitted that I haven't actually seen a disk drive write a partial 
> sector.
> 

Did he work for Maxtor, by any chance?  :-/

A disk drive whose power is cut needs to have enough residual power to 
park its heads (or *massive* data loss will occur), and at that point it 
might as well keep enough on hand to finish an in-progress sector write.

There are two possible sources of onboard temporary power: a large 
enough capacitor, or the rotational energy of the platters (an 
electrical motor also being a generator.)  I don't care which one they 
use, but they need to do something.

	-hpa

