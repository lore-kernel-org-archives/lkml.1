Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZC0Dyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZC0Dyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZC0Dym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:54:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:12433 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbZC0Dym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WQgi6YesIp5pwMbiZ3CcN1vWO1obUy49M4OWtXdaTGJ9EYsdR1ImYQojGsxrfgbCN6
         Zh4xguDQPp30OBhxUvwNRiDlBh0CbTDuwTTNQfx6eVMMro98ybdP1eqoHwcyCI8PoL/I
         jQ2YjkzYbGM4CXTvKjKUlxmgSvEJbItpxkhR0=
MIME-Version: 1.0
In-Reply-To: <20090327015622.GA8405@x200.localdomain>
References: <20090326235116.GA26129@x200.localdomain>
	 <8bd0f97a0903261705v2a28a9bancbb588c4c7fe365f@mail.gmail.com>
	 <20090327015622.GA8405@x200.localdomain>
Date: Thu, 26 Mar 2009 23:54:39 -0400
Message-ID: <8bd0f97a0903262054if3dd9e1w471791314c0622a0@mail.gmail.com>
Subject: Re: [PATCH] Consolidate init_mm definition
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 21:56, Alexey Dobriyan wrote:
> On Thu, Mar 26, 2009 at 08:05:05PM -0400, Mike Frysinger wrote:
>> On Thu, Mar 26, 2009 at 19:51, Alexey Dobriyan wrote:
>> > +++ b/mm/init-mm.c
>> > @@ -0,0 +1,13 @@
>> > +#include <linux/mm_types.h>
>> > +#include <asm/pgtable.h>
>>
>> shouldnt there be a short license blurb ?
>> /* Licensed under the GPL-2 or later. */
>
> Why should it be? Even more, kernel is under GNU GPL 2, not "or later".

my point was to put a blurb.  i frankly dont care about the exact license used.

also, the entire kernel is not under GPL-2 only.  some pieces are "or
later" while others are a completely different license (BSD variant).
-mike
