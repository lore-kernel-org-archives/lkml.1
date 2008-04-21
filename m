Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYDUDP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYDUDP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYDUDPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:15:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63228 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYDUDPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YDCJ72c2dvV8YUwzXuR+IJUxvCrMX+1LGPmIrgAuDaQPBJ7PatsmdncvWS2t5+2IDszvYK3BiA4vTdjQ1lUV3vXFF7t+HTltmWz/zD10hvWQgosJluEXp8ieVWW445d717ss/0BC9yMqrWsBmoHOQgPN6c/vHYymD32sQsxnoWA=
Message-ID: <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
Date: Sun, 20 Apr 2008 20:15:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mitch Bradley" <wmb@firmworks.com>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Cc: "Andres Salomon" <dilinger@queued.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Joseph Fannin" <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <480C0582.9010509@firmworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419031024.GC3503@nineveh.local>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral>
	 <20080419133909.5aa6b63e@ephemeral>
	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	 <480C0582.9010509@firmworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 8:09 PM, Mitch Bradley <wmb@firmworks.com> wrote:
>
>
>
>  Yinghai Lu wrote:
>
> >
> > how about changing to ofw_32.c?
> >
> > YH
> >
> >
>
>  Is your suggestion to change the filename from "ofw.c" to "ofw_32.c"?  That
> seems like a good idea to me.

Yes.

BTW,  why olpc need OFW runtime service?
why not just put the info in in ram with some signiture, so
kernel/util just need to loot at the table if needed?

YH
