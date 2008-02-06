Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbYBFWCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbYBFWCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYBFWCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:02:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYBFWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:02:13 -0500
Message-ID: <47AA2E40.2020701@zytor.com>
Date: Wed, 06 Feb 2008 14:01:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site> <47AA0A2E.30701@zytor.com> <Pine.LNX.4.64.0802061938120.32204@blonde.site> <47AA102F.1070105@zytor.com> <Pine.LNX.4.64.0802062150440.16791@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0802062150440.16791@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 6 Feb 2008, H. Peter Anvin wrote:
>> That sounds like a problem in our overall swap handling, not specifically in
>> tmpfs.  Now, I can't say anything concrete about heavy swap conditions, but in
>> light swap conditions I have measured a 20x performance improvement(!) over
>> ext3 on real workloads.
> 
> Wow, I'm surprised.  I suppose I do jump to thinking of heavy swapping
> when light swapping won't be so bad; but even so, 20x ext3 astonishes
> me - ext3 wouldn't be anyone's choice for fastest, but even so...
> 
> I certainly guess too much and measure too little:
> is there a useful test you could point me to?  TIA
> 

The specific application was this:

- extract a kernel tarball
- "make distclean"
- cp -al the resulting tree
- apply a patch to each tree
- do a diff between the trees
- delete all files

... repeat something like 20,000 times.

	-hpa
