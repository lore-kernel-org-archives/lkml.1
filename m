Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXFRRbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXFRRbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbXFRRbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:31:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43116
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbXFRRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:31:06 -0400
Date: Mon, 18 Jun 2007 10:28:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brendan Conoboy <blc@redhat.com>
cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <4676BEC2.7090809@redhat.com>
Message-ID: <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
 <4676BEC2.7090809@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Brendan Conoboy wrote:

> david@lang.hm wrote:
>>  in my case it takes 2+ days to resync the array before I can do any
>>  performance testing with it. for some reason it's only doing the rebuild
>>  at ~5M/sec (even though I've increased the min and max rebuild speeds and
>>  a dd to the array seems to be ~44M/sec, even during the rebuild)
>
> With performance like that, it sounds like you're saturating a bus somewhere 
> along the line.  If you're using scsi, for instance, it's very easy for a 
> long chain of drives to overwhelm a channel.  You might also want to consider 
> some other RAID layouts like 1+0 or 5+0 depending upon your space vs. 
> reliability needs.

I plan to test the different configurations.

however, if I was saturating the bus with the reconstruct how can I fire 
off a dd if=/dev/zero of=/mnt/test and get ~45M/sec whild only slowing the 
reconstruct to ~4M/sec?

I'm putting 10x as much data through the bus at that point, it would seem 
to proove that it's not the bus that's saturated.

David Lang
