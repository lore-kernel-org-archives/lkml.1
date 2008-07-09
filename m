Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYGISrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYGISrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYGISrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:47:40 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:3725 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYGISrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uYlp50t0wu/d5seHbqzERrNwDVDlffIw7RdDPYIojx7frKw123CbCI51ceSIh2K8I0
         UvzIHiG0gYXHgvZFb1dKUR/91MDc9j1WzPOsKuEUNWnDvk95uYll2vd5L+ZpTZ9kj+Ku
         Adzd9lUo4XHMQ445HpHoQux5Do5fXL7Z1Ax0Q=
Message-ID: <86802c440807091147x71f980d0g829bb2c3ea105090@mail.gmail.com>
Date: Wed, 9 Jul 2008 11:47:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080709184405.GH1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080708230837.GD1678@linux-os.sc.intel.com>
	 <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
	 <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>
	 <20080709175621.GG1678@linux-os.sc.intel.com>
	 <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
	 <4874FF58.5030800@goop.org>
	 <20080709184405.GH1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 11:44 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Wed, Jul 09, 2008 at 11:11:36AM -0700, Jeremy Fitzhardinge wrote:
>> Yinghai Lu wrote:
>> > try to reduce #ifdef CONFIG_X86_64/32, and make 32/64 at the same page.
>> >
>> > could be some regression from early_io_remap unifying from jeremy
>> >
>> > please check attached revert patch.
>>
>> Could my patch "x86_64: there's no need to preallocate
>> level1_fixmap_pgt" be a problem in itself?  It seems sound to me, but
>
> Yep. Reverting it made my system with 2GB memory boot fine again.

only revert that one, or using the big revert patch i sent out.

>
>> none of my other code has any functional dependency on it; it's really
>> just cosmetic.
>
> have you test booted it before making this cosmetic change? :)

he should test system with 4g more RAM

YH
