Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYG0DZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYG0DZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYG0DYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:24:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:34350 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYG0DYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E64H3WQlz7ykR91r0wnzb8aGTo8e6WCqff+QLWWrDBCMFNQ6T0j3bmUtm0b9ccYLKj
         rdJd174rGZT+iXz50eJhD8RkRD4US9JRnbvNqI5GYL++HCqbXpqiC9M0PX8ro/Up85xa
         0kpnx9RFY0xzWQGn7zIUy+bhLIxfuHVTJlRLw=
Message-ID: <86802c440807262024x56ea8defpabcc70f66b27baf9@mail.gmail.com>
Date: Sat, 26 Jul 2008 20:24:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] usb: don't hide bios bug warning
Cc: gregkh@suse.de, mingo@elte.hu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080727015633.479B228C8F1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807261812.15836.yhlu.kernel@gmail.com>
	 <20080727012454.GA22219@suse.de>
	 <86802c440807261848g3bb3e87dh121d1f11f6f64d77@mail.gmail.com>
	 <20080727015633.479B228C8F1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 6:56 PM, David Brownell <david-b@pacbell.net> wrote:
>> >> -                             dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
>> >> +                             dev_printk(KERN_WARNING, &pdev->dev,
>> >> +                                             "EHCI: BIOS handoff failed"
>> >
>> > This is the exact same thing, no change.
>> >
>> > confused,
>>
>> end user will not set CONFIG_USB_DEBUG, so that dev_warn will do nothing.
>
> Yes it does ... KERN_WARNING != KERN_DEBUG, and it's the latter
> which is toggled (via DEBUG) by CONFIG_USB_DEBUG...

you are right,

please forget about the patch.

YH
