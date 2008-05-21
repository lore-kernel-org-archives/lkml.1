Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYEUIyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYEUIyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbYEUIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:54:25 -0400
Received: from visualserver.org ([84.242.66.126]:50414 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbYEUIyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:54:24 -0400
Date: Wed, 21 May 2008 10:54:15 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: Benoit Boissinot <bboissin@gmail.com>
cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
In-Reply-To: <20080520163912.GP7567@pirzuine>
Message-ID: <Pine.LNX.4.64.0805211029250.1736@visualserver.org>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
 <1211229736.5915.86.camel@brick> <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
 <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com>
 <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
 <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com>
 <Pine.LNX.4.64.0805201753430.25485@visualserver.org> <20080520163912.GP7567@pirzuine>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 9CE112FB42.5CD31
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Benoit Boissinot wrote:

> A quick benchmarking (that you should have done at least one your
> computer gives for 100000000 iterations):
> old:
> real	0m1.631s
> user	0m1.628s
> sys	0m0.004s
>
> new:
> real	0m5.553s
> user	0m5.540s
> sys	0m0.004s
>
> So I guess there's no need to discuss this further.

Sorry to disturb you again. But i tested my code against Akinobu's one
and the test result shows my code takes less cpu time than that of
Akinobu's.
Here is the code i used to determine performance
--
#include<stdio.h>
#include<time.h>

int main()
{
 	int i = 100000000;
 	printf("%ld\n", (long)clock());
 	for(; i>0; i--) {
 		bitrev32(0x00face32);
 	}
 	printf("%ld", (long)clock());
}
--
OUTPUT:
[using Akinobu's bitrev32()]
0
6010000

[using my bitrev32()]
0
3990000

And using bitrev8() instead of bitrev32() the result gives the output
like this:
[using Akinobu's bitrev8()]
0
770000

[using my bitrev8()]
0
2360000

My processor is 1.4 GHz one.
I am not forcing you to review my code( or i've no expectation of
inclusion of it ) but its just a curiousity: what is truth behind
the output.

Regards,
Soumya

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

