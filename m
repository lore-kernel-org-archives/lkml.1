Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbYB1VYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbYB1VYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYB1VY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:24:28 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:4581 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYB1VY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:24:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VcEf3qEEd7SinOKcGhSvyjjOA4TYKp48Tgz9l6XXEIFhc/hXpr2UvSH4FdcskbiPzMW3CBuzIF9pD1gWYZ1TP33tp6tPaj9xcm8o6UZWJ7jox4wj0iaYXfUqW9r/cL18sngS3BX4lt94vGJJ0dksdJvCZaVo8wzRJbAU7r9y9+U=
Message-ID: <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com>
Date: Fri, 29 Feb 2008 00:24:22 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080228201613.GA30999@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
	 <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > > Anything else I can do?
>  >
>  > yes, please test the patch below - does it fix the problem?
>

The patch worked well, thanks

I still observe some uneven mouse behaviour during
compilations (linux kernel, make -j 6), like, when I slowly
move the mouse, it would stop for a split of a second every
few seconds (the intervals are not equal). On 2.6.23/24
it works very smooth. Of course, I can't say that the
scheduler is to be blamed. It was only my assumption
because I thought I might be confused by the
non-monotinic time, which I see is not the case.
Any ideas, how to debug this?
