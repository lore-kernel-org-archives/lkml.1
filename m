Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbZCZXxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbZCZXxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbZCZXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:53:19 -0400
Received: from rtr.ca ([76.10.145.34]:60090 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759113AbZCZXxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:53:18 -0400
Message-ID: <49CC156A.4030108@rtr.ca>
Date: Thu, 26 Mar 2009 19:53:14 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: sclark46@earthlink.net
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	<49C87B87.4020108@krogh.cc>	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>	<20090324093245.GA22483@elte.hu>	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>	<20090324103111.GA26691@elte.hu>	<20090324132032.GK5814@mit.edu>	<20090324160353.06a4a5ed@hobbes.virtuouswap> <20090324170559.1667c847@infradead.org> <49CA7AAB.1040506@earthlink.net>
In-Reply-To: <49CA7AAB.1040506@earthlink.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Arjan van de Ven wrote:
..
>> the people that care use my kernel patch on ext3 ;-)
>> (or the userland equivalent tweak in /etc/rc.local)
>>
>>
>>
> Ok, I bite what is the userland tweak?
 
## /etc/rc.local:
for i in `pidof kjournald` ; do ionice -c1 -p $i ; done
