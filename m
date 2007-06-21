Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbXFUOlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbXFUOlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXFUOkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:40:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:52214 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXFUOku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:40:50 -0400
Date: Thu, 21 Jun 2007 10:40:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Mattias Wadenstein <maswan@acc.umu.se>
cc: Neil Brown <neilb@suse.de>, David Chinner <dgc@sgi.com>,
       Avi Kivity <avi@argo.co.il>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <Pine.GSO.4.64.0706211417180.15647@montezuma.acc.umu.se>
Message-ID: <Pine.LNX.4.64.0706211040390.31303@p34.internal.lan>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il>
 <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com>
 <18041.59628.370832.633244@notabene.brown> <Pine.GSO.4.64.0706211417180.15647@montezuma.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Mattias Wadenstein wrote:

> On Thu, 21 Jun 2007, Neil Brown wrote:
>
>> I have that - apparently naive - idea that drives use strong checksum,
>> and will never return bad data, only good data or an error.  If this
>> isn't right, then it would really help to understand what the cause of
>> other failures are before working out how to handle them....
>
> In theory, that's how storage should work. In practice, silent data 
> corruption does happen. If not from the disks themselves, somewhere along the 
> path of cables, controllers, drivers, buses, etc. If you add in fcal, you'll 
> get even more sources of failure, but usually you can avoid SANs (if you care 
> about your data).
>
> Well, here is a couple of the issues that I've seen myself:
>
> A hw-raid controller returning every 64th bit as 0, no matter what's on disk. 
> With no error condition at all. (I've also heard from a collegue about this 
> on every 64k, but not seen that myself.)
>
> An fcal switch occasionally resetting, garbling the blocks in transit with 
> random data. Lost a few TB of user data that way.
>
> Add to this the random driver breakage that happens now and then. I've also 
> had a few broken filesystems due to in-memory corruption due to bad ram, not 
> sure there is much hope of fixing that though.
>
> Also, this presentation is pretty worrying on the frequency of silent data 
> corruption:
>
> https://indico.desy.de/contributionDisplay.py?contribId=65&sessionId=42&confId=257
>
> /Mattias Wadenstein
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Very interesting slides/presentation, going to watch it shortly.
