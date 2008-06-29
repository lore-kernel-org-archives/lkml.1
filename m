Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYF2Hab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYF2Hab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYF2HaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:30:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:26393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYF2HaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K6pxIVLno1hxApaaRfjqk+d9AAbPpiXfx+hq5gbGUJ6l8rqHXDsFBL6Pwezk1x/kIY
         /Va4AFKLOVIqPO632RccdNFeupw6fob7sy36yscL0cWloN2XaOQuDHvjQtJJNMymQd6P
         kaAkcLttqLHOKqKFAliV6UeiFPX7mAcCu77ec=
Message-ID: <86802c440806290030u43129a6dm57a93a07533fa0b9@mail.gmail.com>
Date: Sun, 29 Jun 2008 00:30:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v4
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080629070833.GA4898@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806271538.46829.yhlu.kernel@gmail.com>
	 <200806272247.11971.yhlu.kernel@gmail.com>
	 <200806281749.02000.yhlu.kernel@gmail.com>
	 <20080629070833.GA4898@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 12:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> some end boundary is only page alignment, instead of 2M alignment,
>> so call ker_phycial_mapping_init three times.
>> then don't overmap above the max_low_pfn
>>
>> v2: make init_memory_mapping more solid: start could be any value other than 0
>> v3: fix NON PAE by handling left over in kernel_physical_mapping
>> v4: revert back to v2, and use PMD_SHIFT to calculate boundary
>>     also adjust size for pre-allocated table size
>
> i've got v3 applied to tip/master and it worked well in testing - on the
> old, 512m RAM problem laptop too. So could you send v4 as a delta patch
> instead please, against tip/master?

will. before that delta patch please do test on your 512M system .

YH
