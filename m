Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZLWMtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZLWMtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZLWMt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:49:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZLWMt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:49:28 -0500
Message-ID: <4B3211A3.1090202@redhat.com>
Date: Wed, 23 Dec 2009 14:48:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Chris Wright <chrisw@redhat.com>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com> <20091223121431.GF20539@basil.fritz.box>
In-Reply-To: <20091223121431.GF20539@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 02:14 PM, Andi Kleen wrote:
>> http://www.redhat.com/f/pdf/summit/cwright_11_open_source_virt.pdf
>>
>> See slide 32.  This is without vhost-net.
>>      
> Thanks. Do you also have latency numbers?
>    

No.  Copying Chris.  This was with the tx mitigation timer disabled, so 
you won't see the usual atrocious userspace virtio latencies, but it 
won't be as good as a host kernel implementation since we take a 
heavyweight exit and qemu is pretty unoptimized.

> It seems like there's definitely still potential for improvement
> with messages<4K. But for the large messages they indeed
> look rather good.
>    

There's still a lot of optimization to be done, but I hope this proves 
there is nothing inherently slow about virtio.

-- 
error compiling committee.c: too many arguments to function

