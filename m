Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbZINEE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbZINEE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZINEE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:04:27 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:36493 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZINEE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909131956590.28668@sister.anvils>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100332.55910.ngupta@vflare.org> <4AAB065D.3070602@vflare.org>
	 <Pine.LNX.4.64.0909131956590.28668@sister.anvils>
Date: Mon, 14 Sep 2009 09:34:29 +0530
Message-ID: <d760cf2d0909132104t703c9420y119e51e3bd2c9aa5@mail.gmail.com>
Subject: Re: [PATCH 0/4] compcache: in-memory compressed swapping v2
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc <linux-mm-cc@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:37 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Sat, 12 Sep 2009, Nitin Gupta wrote:
>> On 09/10/2009 03:32 AM, Nitin Gupta wrote:
>> > Project home: http://compcache.googlecode.com/
>> >
>> > * Changelog: v2 vs initial revision
>> >   - Use 'struct page' instead of 32-bit PFNs in ramzswap driver and
>> >   xvmalloc.
>> >     This is to make these 64-bit safe.
>> >   - xvmalloc is no longer a separate module and does not export any symbols.
>> >     Its compiled directly with ramzswap block driver. This is to avoid any
>> >     last bit of confusion with any other allocator.
>> >   - set_swap_free_notify() now accepts block_device as parameter instead of
>> >     swp_entry_t (interface cleanup).
>> >   - Fix: Make sure ramzswap disksize matches usable pages in backing swap
>> >   file.
>> >     This caused initialization error in case backing swap file had
>> >     intra-page
>> >     fragmentation.
>>
>> Can anyone please review these patches for possible inclusion in 2.6.32?
>
> Sorry, I certainly wouldn't be able to review them for 2.6.32 myself.
>
> Since we're already in the merge window, and this work has not yet
> had exposure in mmotm (preferably) or linux-next, I really doubt
> anyone should be pushing it for 2.6.32.
>
> I'd be quite glad to see it and experiment with it in mmotm,
> so it could go into 2.6.33 if all okay.  And I now fully accept
> that the discard/trim situation is so hazy that you are quite
> right to be asking for your own well-defined notifier instead.
>
> But I'm not going to pretend to have reviewed it.
>

Thanks for the pointer Hugh -- I will try to post patches against mmotm later.

Nitin
