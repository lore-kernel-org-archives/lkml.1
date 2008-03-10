Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYCJOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYCJOgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYCJOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:36:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36212 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYCJOgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:36:21 -0400
X-IronPort-AV: E=Sophos;i="4.25,474,1199682000"; 
   d="scan'208";a="49896017"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 1/1 try#2] [VIDEO/FRAMEBUFFER]: add BF52x EZkit Display driver
Date: Mon, 10 Mar 2008 14:35:45 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC12E9A755@limkexm2.ad.analog.com>
In-Reply-To: <Pine.LNX.4.64.0803061906210.20407@anakin>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 1/1 try#2] [VIDEO/FRAMEBUFFER]: add BF52x EZkit Display driver
Thread-Index: Ach/tQG665rVjgcnRdCNNWWZ8CyA+gDBog7Q
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: <geert@linux-m68k.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       "Bryan Wu" <bryan.wu@analog.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, <adaplas@gmail.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Mar 2008 14:35:49.0012 (UTC) FILETIME=[089E6540:01C882BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: geert@linux-m68k.org [mailto:geert@linux-m68k.org]
>Subject: Re: [Linux-fbdev-devel] [PATCH 1/1 try#2] [VIDEO/FRAMEBUFFER]:
add
>BF52x EZkit Display driver
>
>On Thu, 6 Mar 2008, Bryan Wu wrote:
>> On Wed, Mar 5, 2008 at 11:02 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Thu, 31 Jan 2008 00:49:43 +0800 Bryan Wu <bryan.wu@analog.com>
>wrote:
>> >  > +     fbinfo =
>> >  > +         framebuffer_alloc(sizeof(struct bfin_t350mcqbfb_info),
>&pdev->dev);
>> >  > +     if (!fbinfo) {
>> >  > +             ret = -ENOMEM;
>> >  > +             goto out2;
>> >  > +     }
>
>    [...]
>
>> >  > +     fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16,
>GFP_KERNEL);
>> >  > +     if (!fbinfo->pseudo_palette) {
>> >  > +             printk(KERN_ERR DRIVER_NAME
>> >  > +                    "Fail to allocate pseudo_palette\n");
>> >  > +
>> >  > +             ret = -ENOMEM;
>> >  > +             goto out4;
>> >  > +     }
>> >  > +
>> >  > +     memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
>> >
>> >  You just invented kzalloc!
>> >
>>
>> Right
>
>Alternatively, you could embed the pseudo palette inside struct
>bfin_t350mcqbfb_info, so it's allocated by the framebuffer_alloc() call
>above.

This makes the most sense.
Bryan is going to send an updated patch, including your and Andrew's
recommendations.

Thanks and best regards,
Michael
 

>
>Gr{oetje,eeting}s,
>
>						Geert
>
>--
>Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-
>m68k.org
>
>In personal conversations with technical people, I call myself a
hacker.
>But
>when I'm talking to journalists I just say "programmer" or something
like
>that.
>							    -- Linus
Torvalds
