Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXFRV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXFRV4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXFRV42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:56:28 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46912
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbXFRV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:56:26 -0400
Date: Mon, 18 Jun 2007 14:56:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Wakko Warner <wakko@animx.eu.org>
cc: Brendan Conoboy <blc@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <20070618214633.GA15468@animx.eu.org>
Message-ID: <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
References: <18035.23867.576212.859440@notabene.brown>
 <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com>
 <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com>
 <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm> <20070618214633.GA15468@animx.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Wakko Warner wrote:

> Subject: Re: limits on raid
> 
> david@lang.hm wrote:
>> On Mon, 18 Jun 2007, Brendan Conoboy wrote:
>>
>>> david@lang.hm wrote:
>>>> yes, sorry, ultra 320 wide.
>>>
>>> Exactly how many channels and drives?
>>
>> one channel, 2 OS drives plus the 45 drives in the array.
>
> Given that the drives only have 4 ID bits, how can you have 47 drives on 1
> cable?  You'd need a minimum of 3 channels for 47 drives.  Do you have some
> sort of external box that holds X number of drives and only uses a single
> ID?

yes, I'm useing promise drive shelves, I have them configured to export 
the 15 drives as 15 LUNs on a single ID.

I'm going to be useing this as a huge circular buffer that will just be 
overwritten eventually 99% of the time, but once in a while I will need to 
go back into the buffer and extract and process the data.

David Lang
