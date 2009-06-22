Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZFVOcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZFVOcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFVOcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:32:18 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:35274 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbZFVOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:32:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
X-IronPort-AV: E=Sophos;i="4.42,268,1243807200";   d="scan'208";a="16303031"
Message-id: <4A3F95F1.4020507@lfbs.rwth-aachen.de>
Date: Mon, 22 Jun 2009 16:32:17 +0200
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
 <1245119977.6724.40.camel@lts-notebook>
 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
 <1245164395.15138.40.camel@lts-notebook>
 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
 <1245299856.6431.30.camel@lts-notebook> <4A3F7A49.6070805@inria.fr>
In-reply-to: <4A3F7A49.6070805@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Brice Goglin wrote:
> Lee Schermerhorn wrote:
>> On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
>>   
>>
>> Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
>> [along with my shared policy series atop which they sit in my tree].
>> Patches reside in:
>>
>> http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/
>>
>>   
> 
> I gave this patchset a try and indeed it seems to work fine, thanks a
> lot. But the migration performance isn't very good. I am seeing about
> 540MB/s when doing mbind+touch_all_pages on large buffers on a
> quad-barcelona machines. move_pages gets 640MB/s there. And my own
> next-touch implementation were near 800MB/s in the past.

I used a modified stream benchmark to evaluate the performance of Lee's 
and my version of the next-touch implementation. In this low-level 
benchmark is Lee's patch better than my patch. I think that Brice and I 
use the same technique to realize affinity-on-next-touch. Do you use 
another kernel version to evaluate the performance?

Stefan

