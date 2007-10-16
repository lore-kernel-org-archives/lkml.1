Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbXJPGWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbXJPGWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXJPGWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:22:09 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33183 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206AbXJPGWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:22:07 -0400
Message-ID: <4714588C.8010407@davidnewall.com>
Date: Tue, 16 Oct 2007 15:52:04 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
References: <200710112011.22000.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <200710150452.30939.rob@landley.net> <200710160108.38222.nickpiggin@yahoo.com.au>
In-Reply-To: <200710160108.38222.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 15 October 2007 19:52, Rob Landley wrote:
>   
>> On Monday 15 October 2007 8:37:44 am Nick Piggin wrote:
>>     
>>> You really shouldn't configure
>>> so much [swap] unless you do want the kernel to actually use it all, right?
>>>       
>> Two words: "Software suspend".  I've actually been thinking of increasing
>> it on the next install...
>>     
>
> Kernel doesn't know that you want to use it for suspend but not
> regular swapping, unfortunately.
>   

Couldn't you mount swap before suspend and unmount it after resume?
