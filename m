Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZHNEyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZHNEyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZHNEyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:54:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59212 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZHNEyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:54:10 -0400
Message-ID: <4A84EDE4.1080605@vflare.org>
Date: Fri, 14 Aug 2009 10:23:56 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: compcache as a pre-swap area
References: <200908122007.43522.ngupta@vflare.org> <200908130805.36787.a1426z@gawab.com> <d760cf2d0908131031i2305f2deqe20d6a96c8d568af@mail.gmail.com> <200908140702.23947.a1426z@gawab.com>
In-Reply-To: <200908140702.23947.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 09:32 AM, Al Boldi wrote:
> Nitin Gupta wrote:
>> compcache is really not really a swap replacement. Its just another
>> swap device that
>> compresses data and stores it in memory itself. You can have disk
>> based swaps along
>> with ramzswap (name of block device).
>
> So once compcache fills up, it will start to age its contents into normal
> swap?
>

This is desirable but not yet implemented. For now, if 'backing swap' is used, 
compcache will forward incompressible pages to the backing swap device. If 
compcache fills up, kernel will simply send further swap-outs to swap device 
which comes next in priority.

Nitin
