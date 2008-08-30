Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYH3RrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYH3RrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYH3RrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:47:09 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:48655 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYH3RrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aT61iH55lvRa/KYvc3ioxalfIZ0TZff/6idZmxpRw8LV4DRnsZwHj+2VvVO3rGovVV
         HlFIMKrcWNYhyavr4yqj5X3aIaZtASeVfeurYg8gZTIbHdDqFbUxwpY075kfQr+gDFRX
         dIUX5v4wShrd1+LUnK6xdh6eUckC4bveDS8Uc=
Message-ID: <c384c5ea0808301047g7b3658can77b41e5906d306b6@mail.gmail.com>
Date: Sat, 30 Aug 2008 19:47:06 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] shrink printk timestamp field
Cc: "Joe Korty" <joe.korty@ccur.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080830101618.b6c2e1ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827151759.GA10678@tsunami.ccur.com>
	 <20080829163540.634e86d9.akpm@linux-foundation.org>
	 <20080830143808.GA10821@tsunami.ccur.com>
	 <20080830101618.b6c2e1ab.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 30, 2008 at 7:16 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 30 Aug 2008 10:38:08 -0400 Joe Korty <joe.korty@ccur.com> wrote:
>> On Fri, Aug 29, 2008 at 07:35:40PM -0400, Andrew Morton wrote:
>> > On Wed, 27 Aug 2008 11:17:59 -0400 Joe Korty <joe.korty@ccur.com> wrote:
>> >
>> > > Shrink the printk timestamp field.
>>
>> I was looking at it from the point of view of finding out where the
>> boot process was too slow.  For that millisecs is enough.  I am not
>> sure where knowing printk output to the microsec would be useful for
>> solving anything.
>
> Of course it's useful.  If you're working on performance or latency in
> a disk, network or USB driver, microsecond resolution is about right.
>
I second this. If we have timestamps enables, let it be useful for all
current uses. The 3 digits extra are very cheap useful information in
that area (without resorting to more elaborate methods like the
recently merged latency tracer).

Rather than cut 3 digits off, maybe fix some of the too-wide prints
would solve the posters issue better.

Can we please have this patch non-committed or reverted?

Regards,
-- 
Leon
