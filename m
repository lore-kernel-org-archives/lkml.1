Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0BVXMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:12:12 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:43265 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab0BVXMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:12:09 -0500
MIME-Version: 1.0
In-Reply-To: <20100223095118.bed93bac.sfr@canb.auug.org.au>
References: <20100222154816.3604.67114.stgit@angua> <20100222155059.3604.39718.stgit@angua> 
	<20100223095118.bed93bac.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 22 Feb 2010 16:11:48 -0700
X-Google-Sender-Auth: d8680e9758ad4f3f
Message-ID: <fa686aa41002221511r67c79534od562bef934c4d7a7@mail.gmail.com>
Subject: Re: [PATCH 2/2] of/flattree: Make unflatten_device_tree() safe to 
	call from any arch
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 3:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Mon, 22 Feb 2010 08:50:59 -0700 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> - If CONFIG_OF_FLATTREE is not set, then make unflatten_device_tree()
>>   an empty #define.
>
> Any reason not to make this a static inline?
>
>> +#define unflatten_device_tree() do {} while(0)
>
> static inline void unflatten_device_tree(void) {}

No reason, just wasn't thinking of that.  I've changed this.

g.

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
