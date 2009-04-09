Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZDIFIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZDIFIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZDIFIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:08:45 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:59538 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZDIFIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KGkzDNpzOsMVR9YkS0X9H+BU3HCiCFFSbdt/sR6GkjCWmenwhKMHqS4CX/KcgJZYWX
         /DpCiLv2lBNYt9KmqnFnUnrZFguBDYM5tMkPcVlyPd/yjCeYuM3kRX+6F9Ud9PXMgtll
         jU1zvJ51bX3Q2ShAowD/3H6CLVbhemU8I/lrI=
MIME-Version: 1.0
In-Reply-To: <20090408145041.GL12931@elte.hu>
References: <b9df5fa10903271825g62b95e62p6e7006f0594e2c4b@mail.gmail.com>
	 <20090408145041.GL12931@elte.hu>
Date: Thu, 9 Apr 2009 11:08:43 +0600
Message-ID: <b9df5fa10904082208x69dc3b2ex46b8edac7d8cee81@mail.gmail.com>
Subject: Re: [PATCH] x86,apic: Checking kernel option before 
	detect_init_APIC()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 8:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
> Hm, are you sure this is a cleanup only? (i.e. no side-effects)
My quick review over code, i don't think there's any.Unless I'm not
missing anything. Kernel option has been passed when before kernel
starts, so I think it's safe.
>
> Also, even if it's a pure cleanup, wouldnt it be even cleaner to
> propagate this check into detect_init_APIC() - and thus get rid of
> the open-coded disable_apic check altogether?
Yes, could be. How we'll understand that whether apic has been
disabled from kernel option or not (if we requires later on)?

Rakib
>
>        Ingo
>
