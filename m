Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbXFRSTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbXFRSTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761035AbXFRSSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:18:52 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40045
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbXFRSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:18:51 -0400
Date: Mon, 18 Jun 2007 11:16:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brendan Conoboy <blc@redhat.com>
cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <4676C9FF.7060607@redhat.com>
Message-ID: <Pine.LNX.4.64.0706181113050.12717@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
 <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
 <4676C9FF.7060607@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Brendan Conoboy wrote:

> david@lang.hm wrote:
>>  I plan to test the different configurations.
>>
>>  however, if I was saturating the bus with the reconstruct how can I fire
>>  off a dd if=/dev/zero of=/mnt/test and get ~45M/sec whild only slowing the
>>  reconstruct to ~4M/sec?
>>
>>  I'm putting 10x as much data through the bus at that point, it would seem
>>  to proove that it's not the bus that's saturated.
>
> I am unconvinced.  If you take ~1MB/s for each active drive, add in SCSI 
> overhead, 45M/sec seems reasonable.  Have you look at a running iostat while 
> all this is going on?  Try it out- add up the kb/s from each drive and see 
> how close you are to your maximum theoretical IO.

I didn't try iostat, I did look at vmstat, and there the numbers look even 
worse, the bo column is ~500 for the resync by itself, but with the DD 
it's ~50,000. when I get access to the box again I'll try iostat to get 
more details

> Also, how's your CPU utilization?

~30% of one cpu for the raid 6 thread, ~5% of one cpu for the resync 
thread

David Lang
