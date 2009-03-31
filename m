Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbZCaBx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbZCaBx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZCaBxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:53:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20998 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZCaBxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W0z0dTl1VdLvTBEF+Tu6ccvoU1+AY+VKFMERiUvFUyQ9I9vxbGTiyNocrexOEMEBdK
         x/5E/qEMOVsW8Ky0vId1d1RGbp4YsRTeq+ltVD/ZafFv3II2pk59R3xHm/qDE5VFFMmx
         A3db+5gbDe8s4PD47mjItmtxIq1SZJJMiNMW8=
MIME-Version: 1.0
Reply-To: chris.leech@gmail.com
In-Reply-To: <20090330225644.GA28098@cleech-lnx.jf.intel.com>
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com>
	 <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com>
	 <20090327163438.GA10185@cleech-lnx.jf.intel.com>
	 <49CDAAD5.9010202@kernel.org>
	 <20090330221034.GC27774@cleech-lnx.jf.intel.com>
	 <86802c440903301525h41481c98lfff9b40b98b2d7f3@mail.gmail.com>
	 <20090330225644.GA28098@cleech-lnx.jf.intel.com>
Date: Mon, 30 Mar 2009 18:53:45 -0700
X-Google-Sender-Auth: 75eebade24441278
Message-ID: <41b516cb0903301853i37aaae1ft4e8d1de5e3bf28f4@mail.gmail.com>
Subject: Re: [PATCH] irq: mask irq before move it
From: Chris Leech <christopher.leech@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 3:56 PM, Chris Leech
<christopher.leech@intel.com> wrote:
> On Mon, Mar 30, 2009 at 03:25:07PM -0700, Yinghai Lu wrote:
>> On Mon, Mar 30, 2009 at 3:10 PM, Chris Leech
>> <christopher.leech@intel.com> wrote:
>> > On Fri, Mar 27, 2009 at 09:43:01PM -0700, Yinghai Lu wrote:
>> >>
>> >> Imapct: fix panic
>> >>
>> >> try to mask the irq, before move the irq desc
>> >>
>> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >
>> > This change did not fix the issue I'm seeing.  The following output was
>> > generated with 2.6.29 + this patch.
>> >
>> > I will send system information and kernel config separately.
>>
>> in your /proc/interrupts
>>
>>  57:          0          0          0          0          0          0
>>          0          0   PCI-MSI-edge      aerdrv, pciehp
>>
>> how can that be shared?
>
> I don't know, I'm not really up on how drivers that deal with
> PCI-Express switch ports work.  I'd be happy to test again with both
> advances error reporting and hotplug removed from my configuration.

Removing AER and PCI hotplug did not change anything.  There were no
shared MSI interrupts showing in that case.

- Chris
