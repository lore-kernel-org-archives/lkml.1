Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbYETQj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbYETQj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYETQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:39:12 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:46409 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYETQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:39:11 -0400
Date: Tue, 20 May 2008 18:39:12 +0200
From: Benoit Boissinot <bboissin@gmail.com>
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
Message-ID: <20080520163912.GP7567@pirzuine>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> <1211229736.5915.86.camel@brick> <Pine.LNX.4.64.0805201254240.18899@visualserver.org> <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com> <Pine.LNX.4.64.0805201716160.25111@visualserver.org> <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com> <Pine.LNX.4.64.0805201753430.25485@visualserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805201753430.25485@visualserver.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:57:37PM +0200, Soumyadip Das Mahapatra wrote:
> On Tue, 20 May 2008, Benoit Boissinot wrote:
>> On Tue, May 20, 2008 at 5:25 PM, Soumyadip Das Mahapatra
>> <kernelhacker@visualserver.org> wrote:
>>> I know that my bitrev8() takes more instructions than that
>>> of yours. But we have to think about faster access of cpu cache over that
>>> of memory cache(which your bit_rev_table uses).
>>
>> I didn't review your patch, sorry.
>> But I'm pretty sure that your patch won't be considered unless you
>> provide benchmarks
>> with numbers for different CPU/architecture.
>> Ideally you should provide a script to test the correctness and the
>> performance of your
>> change that anyone could run on his computer.
>
> Thanks Benoit for giving me such a precious advice. But sorry, I dont
> have any benchmarking system in my hand(how can i have? i am just a
> student, not a professional).
> So if you do me a favour and kindly do it for me, please :-)

A quick benchmarking (that you should have done at least one your
computer gives for 100000000 iterations):
old:
real	0m1.631s
user	0m1.628s
sys	0m0.004s

new:
real	0m5.553s
user	0m5.540s
sys	0m0.004s

So I guess there's no need to discuss this further.

regards,

Benoit

-- 
:wq
