Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYIORfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYIORfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYIORe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:34:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54138 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYIORe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a1VEkYyoxZSA5p8QiWTatCfhY0z81tYA72OB3gJX2eIV032DidgGDUJ7TCesK3a2O6
         LoyDJ2s0WGhaJfm82tvJCxH9ovmayGq+XHN+Ph8CzkLIGL4avp9pCOw6IQIp2UbhOQq2
         Z0Vy7Eh2p0CkwqXPp44r5mfdNkbAEAQrHjpE4=
Message-ID: <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
Date: Mon, 15 Sep 2008 10:34:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48CE9A5C.1030603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CE983C.8040709@zytor.com>
	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
	 <48CE9A5C.1030603@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 10:24 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> some guys complained that it is even too verbose with KERN_DEBUG
>>
>
> I can understand the desire to enable filtering on a subsystem-by-subsystem
> basis, but I think rather than doing a subsystem-specific hack we should do
> something that any subsystem can use.
>
> Perhaps we could extend the current <level> hack to include a subsystem,
> something like:
>
> <7><x86>Your blort driver seems to be befudged, trying blarfing.
>
> ... and something like "loglevel=x86:7,acpi:3,..."
>
sounds good.

every subsystem will have
x86_printk
acpi_printk
pci_printk

YH
