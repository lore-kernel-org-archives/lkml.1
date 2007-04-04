Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXDDWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXDDWDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXDDWDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:03:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXDDWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:03:21 -0400
Message-ID: <4614207F.6060708@online.de>
Date: Thu, 05 Apr 2007 00:02:39 +0200
From: Thomas Bittermann <t.bittermann@online.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
References: <461408A6.5010005@online.de> <20070404140007.15aa1893.akpm@linux-foundation.org> <461414E7.6080302@online.de> <20070404143052.b1572cc9.akpm@linux-foundation.org> <20070404213654.GA22326@elte.hu>
In-Reply-To: <20070404213654.GA22326@elte.hu>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+VEadbIze4Hw8t6MoqonehUhkKmj4w8+VqHZ0
 tB1Vs88Vj1/efAeEfmIj1+evPOPLEUU9KmlMzpk7VSUiRr7hs5
 MNVSpyuU+atp/AztwTYPA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5 
>>> (http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme). 
>>> dm-raid4-5.c uses jiffies_to_timeval() ...
>> Fair enough.
>>
>> John/Ingo/Thomas: have you any problems with exporting the above to 
>> modules (with EXPORT_SYMBOL)?
> 
> i have no problems with that. I think it was even a traditional api, but 
> inlined.
Yes it was inlined before and got lost somewhere between 2.6.20 and 2.6.21-rcX - don't know
exactly which one it was (see http://lkml.org/lkml/2007/1/23/198)

Cheers & thanks
Thomas
