Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXFSUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXFSUwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXFSUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:51:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:41991
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXFSUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:51:56 -0400
Date: Tue, 19 Jun 2007 13:51:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Wakko Warner <wakko@animx.eu.org>, Brendan Conoboy <blc@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <20070619201111.GQ10008@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0706191350030.26701@asgard.lang.hm>
References: <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
 <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm>
 <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm>
 <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
 <20070618214633.GA15468@animx.eu.org> <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
 <20070619201111.GQ10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Lennart Sorensen wrote:

> On Mon, Jun 18, 2007 at 02:56:10PM -0700, david@lang.hm wrote:
>> yes, I'm useing promise drive shelves, I have them configured to export
>> the 15 drives as 15 LUNs on a single ID.
>>
>> I'm going to be useing this as a huge circular buffer that will just be
>> overwritten eventually 99% of the time, but once in a while I will need to
>> go back into the buffer and extract and process the data.
>
> I would guess that if you ran 15 drives per channel on 3 different
> channels, you would resync in 1/3 the time.  Well unless you end up
> saturating the PCI bus instead.
>
> hardware raid of course has an advantage there in that it doesn't have
> to go across the bus to do the work (although if you put 45 drives on
> one scsi channel on hardware raid, it will still be limited).

I fully realize that the channel will be the bottleneck, I just didn't 
understand what /proc/mdstat was telling me. I thought that it was telling 
me that the resync was processing 5M/sec, not that it was writing 5M/sec 
on each of the two parity locations.

David Lang
