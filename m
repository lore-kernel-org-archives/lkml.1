Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212Ab0A3ANh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0A3ANh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 19:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863Ab0A3ANg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 19:13:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab0A3ANg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 19:13:36 -0500
Message-ID: <4B6378C9.9000408@zytor.com>
Date: Fri, 29 Jan 2010 16:09:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: John Kacur <jkacur@redhat.com>, eranian@google.com, fweisbec@gmail.com,
       paulus@samba.org, mingo@elte.hu, davem@davemloft.net,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
References: <20100122155044.391857484@chello.nl>	 <20100122155535.797688466@chello.nl>	 <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com> <1264763149.4283.2215.camel@laptop>
In-Reply-To: <1264763149.4283.2215.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 03:05 AM, Peter Zijlstra wrote:
> On Fri, 2010-01-29 at 11:32 +0100, John Kacur wrote:
>>
>> I like it. Maybe provide a comment that this provides the Hamming weight, it
>> took me a second to realize what this was.
> 
> its called _H_weight for crying out loud.
> 

True... although in computer architecture, when talking about bits, I
think you find that the term population count (popcount) is more readily
recognized.

	-hpa
