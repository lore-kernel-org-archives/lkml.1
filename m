Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZHMRbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZHMRbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZHMRbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:31:49 -0400
Received: from mail-gx0-f215.google.com ([209.85.217.215]:39757 "EHLO
	mail-gx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZHMRbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <200908130805.36787.a1426z@gawab.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <4A837D5A.3070407@vflare.org> <200908130805.36787.a1426z@gawab.com>
Date: Thu, 13 Aug 2009 23:01:49 +0530
Message-ID: <d760cf2d0908131031i2305f2deqe20d6a96c8d568af@mail.gmail.com>
Subject: Re: compcache as a pre-swap area (was: [PATCH] swap: send callback 
	when swap slot is freed)
From: Nitin Gupta <ngupta@vflare.org>
To: Al Boldi <a1426z@gawab.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:35 AM, Al Boldi<a1426z@gawab.com> wrote:
> Nitin Gupta wrote:
>> BTW, last time compcache was not accepted due to lack of performance
>> numbers. Now the project has lot more data for various cases:
>> http://code.google.com/p/compcache/wiki/Performance
>> Still need to collect data for worst-case behaviors and such...
>
> I checked the link, and it looks like you are positioning compcache as a swap
> replacement.  If so, then repositioning it as a compressed pre-swap area
> working together with normal swap-space, if available, may yield a much more
> powerful system.
>
>

compcache is really not really a swap replacement. Its just another
swap device that
compresses data and stores it in memory itself. You can have disk
based swaps along
with ramzswap (name of block device).

Nitin
