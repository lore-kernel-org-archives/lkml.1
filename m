Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXG2RgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXG2RgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764064AbXG2RgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:36:15 -0400
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:57655 "EHLO
	smtpq3.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298AbXG2RgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:36:14 -0400
Message-ID: <46ACCF7A.1080207@gmail.com>
Date: Sun, 29 Jul 2007 19:33:46 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
       Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46AC4B97.5050708@gmail.com>	 <20070729141215.08973d54@the-village.bc.nu>	 <46AC9F2C.8090601@gmail.com>	 <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>	 <46ACAB45.6080307@gmail.com>	 <2c0942db0707290820r2e31f40flb51a43846169a752@mail.gmail.com>	 <46ACB40C.2040908@gmail.com>	 <2c0942db0707290904n4356582dt91ab96b77db1e84e@mail.gmail.com>	 <46ACC76A.3080303@gmail.com> <2c0942db0707291019q14f309d0jab3bf083aa37d707@mail.gmail.com>
In-Reply-To: <2c0942db0707291019q14f309d0jab3bf083aa37d707@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2007 07:19 PM, Ray Lee wrote:

>> The program is not a real-world issue and if you do not consider it a useful
>> boundary condition either (okay I guess), how would log structured swap help
>> if I just assume I have plenty of free swap to begin with?
> 
> Is that generally the case on your systems? Every linux system I've
> run, regardless of RAM, has always pushed things out to swap.

For me, it is generally the case yes. We are still discussing this in the 
context of desktop machines and their problems with being slow as things 
have been swapped out and generally I expect a desktop to have plenty of 
swap which it's not regularly going to fillup significantly since then the 
machine's unworkably slow as a desktop anyway.

> And once there's something already in swap, you now have a packing
> problem when you want to swap something else out.

Once we're crammed, it gets to be a different situation yes. As far as I'm 
concerned that's for another thread though. I'm spending too much time on 
LKML as it is...

Rene.



