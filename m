Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZFRT3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZFRT3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZFRT3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:29:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZFRT3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:29:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=mPM4ySTNGJMmNb3Mo4RqijQmaGdTmKJrFCC5CWziXJV/tAHBulQze17D9ixpPLk/J
	dPwPaTa1I9cVfy9h7ZtCw==
MIME-Version: 1.0
In-Reply-To: <20090618102026.20c54b6a@lxorguk.ukuu.org.uk>
References: <1245285075-20022-1-git-send-email-swetland@google.com>
	 <1245285075-20022-2-git-send-email-swetland@google.com>
	 <20090618102026.20c54b6a@lxorguk.ukuu.org.uk>
Date: Thu, 18 Jun 2009 12:29:44 -0700
Message-ID: <a55d774e0906181229t5d71622dh5e7403218b88a4b6@mail.gmail.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard 
	serial peripheral.
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 2:20 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 17 Jun 2009 17:31:13 -0700
> Brian Swetland <swetland@google.com> wrote:
>
>> From: Robert Love <rlove@google.com>
>>
>> Provides support for the "lowspeed" UARTs on the MSM7k and QSD8k
>> family of SoCs from Qualcomm.  Serial console support included.
>>
>> Signed-off-by: Robert Love <rlove@google.com>
>> Signed-off-by: Brian Swetland <swetland@google.com>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
>
> If you fold other peoples patches into something please preserve the
> authorship data and preferably keep the two patches separated as it
> otherwise causes merge problems if stuff (eg the serial patches) goes via
> two trees at once.

Ah, sorry about that -- I can resend the revised patch that your patch
applies against (but without your changes merged in).  Previously, for
the ARM stuff I got the impression that a single patch folding small
changes in was preferred, but I may have misunderstood the workflow.

> At the moment the ttydev tree has
>        -> your original -> my (intel's I guess) fixes ->
>
> and if the updated one also went in via the arm tree git can't always
> figure out what is going on.
>
> If its only going by one path and you know that then just adding an
> additional note on the authorship of updates is fine but this being
> serial/tty and ARM is likely to hit both trees.
>
> Alan
>
