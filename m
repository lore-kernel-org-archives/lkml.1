Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYCCVmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYCCVmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbYCCVmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:42:37 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:42239 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbYCCVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nU2zj4gvdx8mydo6FN606e3n5ZPubjSrPaLKIUt7eobiNUwCCFbJ9G9+oBfMHWhoUNYsWpMRIU3b95JP/SKYKj6QNNtBtLlIRk+0NvqOkRbD7iERg3LTBd74ssfYjh/RPfZWH+9OYWb4lp6GNrYAllEMAcg+dIjx6zWZLajfbwE=
Message-ID: <d6c8ef150803031342r567aab86x776dc2a8b73714b6@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:42:29 +0100
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: High resolution timers on AT91SAM926x
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <200803031039.57909.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011457.40857.david-b@pacbell.net>
	 <d6c8ef150803030226m75f68bffvfa20feba9133b247@mail.gmail.com>
	 <200803031039.57909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I had CONFIG_ATMEL_TCLIB enabled, but not TCB_CLKSRC and
TCB_CLKSRC_BLOCK=0. With all those options, I finally have HRT
functionality. But, strange thing is that jitter of my little example
(get time, sleep 1ms, get time, show the difference) is around 250us.
Maybe this is normal for this architecture?

System is (as noted on rt.wik site) very slow with NO_HZ option enabled.

Thanks again!

On Mon, Mar 3, 2008 at 7:39 PM, David Brownell <david-b@pacbell.net> wrote:
> On Monday 03 March 2008, Bosko Radivojevic wrote:
>  > thank you for the reply. But, I'm getting pretty strange behavior.
>
>  Presumably you got different results when your Kconfig
>  enabled a HRT/NO_HZ capable clockevent source, instead
>  of just the PIT?
>
>  CONFIG_ATMEL_TCLIB=y
>
>
> CONFIG_ATMEL_TCB_CLKSRC=y
>  CONFIG_ATMEL_TCB_CLKSRC_BLOCK=0
>
