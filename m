Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbXLRTSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbXLRTSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 14:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXLRTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 14:18:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:48822 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXLRTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 14:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=COxh9zVk24fNYcWzPo+dSDH5xzKCqxlewq7b8MSgk0mkumK3T5RoF4j5bIKZSOMhjGodtQHr64bmkJb9lcxghVIGpFgkrHOE1CDDd00l2MR0i/6rrSgapI1Abc285nh2vyOBgLnKiViRy/LyxA7p5ATkdRbrRJqLaa9Glgp6Zc0=
Message-ID: <3efb10970712181118w58daac1dw52f776ccf1dd0eae@mail.gmail.com>
Date: Tue, 18 Dec 2007 20:18:30 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071218181921.2478baa9@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
	 <20071218181921.2478baa9@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: d28c8a00b555cfe8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> > BTW: Attached I have added a 2nd patch that I use for Preempt-RT. (For
> > cleaner startup, and to get rid of useless IRQ-threads.
>
> Hrm. That assumption isn't valid on AVR32...on AP7000, for example,
> IRQ1 is used by the LCD controller.

In that case, forget that (dirty) patch completely for now. It does
not break things on Preempt-RT, we only will have a IRQ-1 kernel
thread that is never scheduled. (Of which I think is actually a
irq-manage bug, if there are no handlers that are scheduled on that
thread, it should not even start the thread.)

I will verify/test the complete patchset tomorrow.

Kind Regards,

Remy
