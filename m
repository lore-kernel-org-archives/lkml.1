Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZLBL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZLBL0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZLBL0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:26:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:37166 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZLBL0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:26:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U0IKqrrPzc9jPNbkGsqNf/KuyxnODFKje308jhoEou/L3gK72Nz3RBZ4IMFYU45/Yl
         BRco0LZcetAG3vB1qgv+e61PzWpVZJwrAQhos75GDtjuYVMXzkLydaprn2tweDTPWAiG
         mqDd2VlIY7u6rvuL1s9zqSsZcN1n0zj4xBPEc=
MIME-Version: 1.0
In-Reply-To: <2cd4ff050912020309j6e7c0ae9n89c011889b09f3e1@mail.gmail.com>
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com>
	 <4B151A86.1060505@ladisch.de> <4B1533B0.1030007@compro.net>
	 <alpine.DEB.2.00.0912011003290.20551@makko.or.mcafeemobile.com>
	 <2cd4ff050912020309j6e7c0ae9n89c011889b09f3e1@mail.gmail.com>
Date: Wed, 2 Dec 2009 13:26:24 +0200
Message-ID: <2cd4ff050912020326rcd2d7ffseb481ca736cd7d8c@mail.gmail.com>
Subject: Re: Signal from kernel space to user space
From: Mai Daftedar <mai.daftedar@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Mark Hounschell <markh@compro.net>, Clemens Ladisch <clemens@ladisch.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all for the help,
 I needed to use signals just as interrupt signal from the kernel
space so that when a certain change occurs I'd be notified in the
userspace
 I used send_sig _info and it worked :)..The problem was with the
signal number I using a wong one..

 Thanks


> On Tue, Dec 1, 2009 at 8:05 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>>
>> On Tue, 1 Dec 2009, Mark Hounschell wrote:
>>
>> > If no "information" is required, which of these are the fastest, say from an interrupt handler?
>> > I have a PCI card that handles external interrupts from the outside world and does nothing but
>> > report those external interrupts to userland. We use send_sig or wake_up_process depending
>> > on whether userland is going to wait for it or not. If there is a better/faster way I would be
>> > very interested.
>>
>> eventfd is. eventfd_signal() is also callable from non-sleeping contexts.
>>
>>
>> - Davide
>>
>>
>
