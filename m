Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZC3WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZC3WZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZC3WZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:25:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:7423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZC3WZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q2e9gzF1m95PZT1ewiCu26Dgn5B2GhPJfyC/Sl+IcOEHgUQh3/2FIVlZiH9cwiXNMT
         toMg6HMJDvgBzZDGzgpaV50k7SLrYlQMvSZpBgT0QwLsbAQH2qI8B0YptFv6wabi66TA
         CwlUxZw0mFd6PH25X+7z611TPEu71WqyQw8c0=
MIME-Version: 1.0
In-Reply-To: <20090330221034.GC27774@cleech-lnx.jf.intel.com>
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com>
	 <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com>
	 <20090327163438.GA10185@cleech-lnx.jf.intel.com>
	 <49CDAAD5.9010202@kernel.org>
	 <20090330221034.GC27774@cleech-lnx.jf.intel.com>
Date: Mon, 30 Mar 2009 15:25:07 -0700
X-Google-Sender-Auth: 17db3c7b4b85734f
Message-ID: <86802c440903301525h41481c98lfff9b40b98b2d7f3@mail.gmail.com>
Subject: Re: [PATCH] irq: mask irq before move it
From: Yinghai Lu <yinghai@kernel.org>
To: Chris Leech <christopher.leech@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 3:10 PM, Chris Leech
<christopher.leech@intel.com> wrote:
> On Fri, Mar 27, 2009 at 09:43:01PM -0700, Yinghai Lu wrote:
>>
>> Imapct: fix panic
>>
>> try to mask the irq, before move the irq desc
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> This change did not fix the issue I'm seeing.  The following output was
> generated with 2.6.29 + this patch.
>
> I will send system information and kernel config separately.

in your /proc/interrupts

 57:          0          0          0          0          0          0
         0          0   PCI-MSI-edge      aerdrv, pciehp

how can that be shared?

YH
