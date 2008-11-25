Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYKYKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYKYKqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYKYKqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:46:05 -0500
Received: from lucidpixels.com ([75.144.35.66]:57722 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbYKYKqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:46:03 -0500
Date: Tue, 25 Nov 2008 05:46:01 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Eric Sandeen <sandeen@sandeen.net>, Stian Jordet <liste@jordet.net>,
       Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <20081125104415.GA17304@infradead.org>
Message-ID: <alpine.DEB.1.10.0811250544530.19316@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet> <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com> <1227476908.32357.5.camel@chevrolet> <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan> <1227485956.5145.10.camel@chevrolet>
 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet> <492B5684.2080107@sandeen.net> <alpine.DEB.1.10.0811250456010.16346@p34.internal.lan> <20081125104415.GA17304@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Nov 2008, Christoph Hellwig wrote:

> On Tue, Nov 25, 2008 at 04:56:24AM -0500, Justin Piszcz wrote:
>> barriers enabled:
>>
>> $ time bash -c 'tar xf linux-2.6.27.7.tar; sync'
>> block 573932: ** Block of NULs **
>> Total bytes read: 293857280 (281MiB, 1.9MiB/s)
>>
>> real    2m40.643s
>> user    0m0.194s
>> sys     0m1.541s
>>
>> barriers disabled:
>>
>> time bash -c 'tar xf linux-2.6.27.7.tar; sync'
>> block 573932: ** Block of NULs **
>> Total bytes read: 293857280 (281MiB, 11MiB/s)
>>
>> real    0m27.612s
>> user    0m0.182s
>> sys     0m1.617s
>
> That's worse than usual, and even the no-barriers numbers are still
> really bad.  What kind of disk and controller is this?  Did you
> try to disable the cache with hdparm and see what that gives?
>

WD 750G on ICH7

Device Model:     WDC WD7500AAKS-00RBA0
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA 
AHCI Controller (rev 01)

I've not tried playing with the cache.

Justin.
