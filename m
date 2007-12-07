Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXLGFzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXLGFzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXLGFzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:55:20 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:47028 "EHLO
	mail71-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXLGFzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:55:18 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <4758E03E.8090409@am.sony.com>
Date: Thu, 06 Dec 2007 21:55:10 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <47537F2E.2070204@am.sony.com> <b91f94dd5b35247fecf52090c0b3890f@bga.com> <Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be> <20071205151147.9db4640b.akpm@linux-foundation.org> <47573806.8000808@am.sony.com> <Pine.LNX.4.62.0712060839340.9929@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0712060839340.9929@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2007 05:55:13.0398 (UTC) FILETIME=[BBE97160:01C83895]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 5 Dec 2007, Geoff Levand wrote:
>> Andrew Morton wrote:
>> > On Wed, 5 Dec 2007 10:52:48 +0100 (CET)
>> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
>> > 
>> >> --------------------------------------------------------------------------------
>> >> Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
>> >> 
>> >> sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
>> >> whether the allocation succeeded before proceeding to touch the allocated
>> >> memory.
>> >> 
>> >> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> >> 
>> >> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> >> ---
>> >> FIXME There are still some possible memory leaks in sparse_add_one_section():
>> >>   - usemap is never deallocated
>> >>   - __kfree_section_memmap() is a not yet implemented dummy
>> > 
>> > I already had
>> > 
>> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
>> > and
>> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
>> > 
>> > queued.  Do they fix the problem, and should they be merged in 2.6.24?
>> 
>> No, a quick test shows it just panics in a different place.  Geert's
>> patch does also.
> 
> What do you mean, that it still paniced after my patch?
> 
> The kernel did boot succesfully for me when passing ps3fb=48M. Userspace saw 58
> MiB (128 MiB - kernelsize - 48 MiB(ps3fb)).
> 
> I did not try kexec, though.

On looking at it, your patch should have worked, so I guess I didn't boot the
correct image, or something like that.  Sorry.

-Geoff

