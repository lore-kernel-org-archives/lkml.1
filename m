Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYIFR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYIFR1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYIFR11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:27:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:43811 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYIFR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KFf2XZyic7lVxePLbTmpPVKcgYgvc+eZr8eSce5pJov+oEjM+QtXFZIsoZO2KGXBPB
         /ke8NVtWO8d1W+tVYBktd1dRshjP09YVYWrEFJ8jOvzhHKuwSlMD+HXY86msYaR6rQLg
         YM2Eyu0mDC4KPDMy6C+KjCXkgGBtvL8KO/HU4=
Message-ID: <86802c440809061027x403f80dj403c49e14df956c3@mail.gmail.com>
Date: Sat, 6 Sep 2008 10:27:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] dyn_array: using %pF instead of print_fn_descriptor_symbol
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080906171803.GJ4856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080829152053.92fa6fd4.akpm@linux-foundation.org>
	 <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
	 <20080829155319.dc76b1c0.akpm@linux-foundation.org>
	 <20080906170944.GG4856@elte.hu>
	 <86802c440809061016n2fa6d8te0dd486ceeb6135d@mail.gmail.com>
	 <20080906171803.GJ4856@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 10:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Sat, Sep 6, 2008 at 10:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Andrew Morton <akpm@linux-foundation.org> wrote:
>> >
>> >> >     ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
>> >> >     if (!ptr)
>> >> >             panic("Can not alloc dyn_alloc\n");
>> >>
>> >> Why duplicate the panic()?  Just call __alloc_bootmem().
>> >
>> > agreed.
>> >
>> >> > #ifdef CONFIF_GENERIC_HARDIRQS
>> >>
>> >> That doesn't appear to have been very well tested?
>> >
>> > on non-genirq systems? Most likely. If then most testing they get is
>> > from cross-build tools. Few if any actual users.
>> >
>> >> The code has a few coding-style glitches which checkpatch can detect.
>> >
>> > yeah. Yinghai, could you please fix them?
>>
>> already in tip/master and -mm
>> except  first one.
>
> that needs fixing too i think. We dont really want to sprinkle the code
> with various specific panics.

ok, please check that in another mail.

YH
