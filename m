Return-Path: <linux-kernel-owner+w=401wt.eu-S932660AbYEUXYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbYEUXYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbYEUXXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:23:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:50412 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbYEUXXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OslKZf/er31k/j0VI5ufsK5QV+dNKDrzLeQdcNds77SoWMoGEfscmxTnzK2B+ZdiDoYibZRmb9x1PrOHh1Du0fIDpJf1WZ064vB5acwt9g3VbGWNGKO/cO6D1dFLSYAHGpwgoshYrj5Mtp4/nZvb97Xzf7cQGaXAqq2Se6V7k5g=
Message-ID: <8bd0f97a0805211623o1a33f6d2k1780a84ccdd9c217@mail.gmail.com>
Date: Wed, 21 May 2008 19:23:51 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Cc: cooloney@kernel.org, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com
In-Reply-To: <20080521161137.ed4bd6cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	 <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
	 <20080520010223.5e55d074.akpm@linux-foundation.org>
	 <8bd0f97a0805201741h13e44c4dkead97118d7d137e8@mail.gmail.com>
	 <20080521161137.ed4bd6cf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 7:11 PM, Andrew Morton wrote:
> On Tue, 20 May 2008 20:41:13 -0400 "Mike Frysinger" wrote:
>> > This:
>> >
>> >> -#if defined(__arm__) || defined(__mips__) || defined(__avr32__)
>> >> +#if defined(__arm__) || defined(__mips__) || defined(__avr32__) || defined(bfin)
>> >
>> > should probably be using CONFIG_foo but that might not work if it's to
>> > be preprocessed by userspace.  I didn't look.  Plus that'd be
>> > off-topic.
>>
>> it should be defined(__bfin__) at least.
>
> Well I made that change, but this all has a rather untested feeling to
> it.

both will work with Blackfin toolchains, the latter form is obviously preferred
-mike
