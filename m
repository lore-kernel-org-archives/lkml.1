Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYHUKp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYHUKp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYHUKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:45:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbYHUKpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:45:08 -0400
Message-ID: <48AD46C4.30207@redhat.com>
Date: Thu, 21 Aug 2008 06:43:16 -0400
From: Ric Wheeler <rwheeler@redhat.com>
Reply-To: rwheeler@redhat.com
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Eric Sandeen <sandeen@sandeen.net>, Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net> <20080821052604.GM20055@kernel.dk>
In-Reply-To: <20080821052604.GM20055@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Aug 20 2008, Eric Sandeen wrote:
>   
>> Milan Broz wrote:
>>     
>>> Hi,
>>>
>>> I run some barrier tests over device-mapper (which currently doesn't
>>> support barrier bio at all) and even if I set barrier=1 in ext3 mount,
>>> there is never any bio with barrier flag... (in 2.6.27-rc)
>>>
>>> How is the barrier=1 flag supposed to work in ext3 (JBD) now?
>>>       
>> Milan, you're right.  Ric saw this same strange behavior when doing some
>> benchmarking with and without barriers; Chris noticed the change in
>> submit_bh; I was about to write up a similar patch to what you've sent
>> already.  Jens, does Milan's fix look good to you?
>>     
>
> Yep looks good, thanks a lot Milan! I'll send in the patch, unless I'm
> badly mistaken we need it for 2.6.26-stable as well.
>
>   

I think we definitely need it there as well, thanks!

Ric

