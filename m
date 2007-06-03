Return-Path: <linux-kernel-owner+w=401wt.eu-S1763891AbXFCBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763891AbXFCBps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 21:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbXFCBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 21:45:41 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:1822 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763028AbXFCBpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 21:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LDhRlyuxMHCJLzCviRardL+xSg9NjwHUrsQJKMwnH5V0vDlxiv+EtuI2BP9u3wn95gtgpqw+C96yEdb0ev40bkqWxuWa/MkNn/4KbfhiGtKQa95I7cmWNLuJdxb0NtOyk+tyDLyWcPyb/kATJQt2e5tATVZR2htgFyXwKYdK+dE=
Message-ID: <a781481a0706021845y2fd8442fy388c0df58aabcedc@mail.gmail.com>
Date: Sun, 3 Jun 2007 07:15:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Device Driver Etiquette
Cc: "Matthew Fredrickson" <creslin@digium.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1180826520.2815.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
	 <1180826520.2815.3.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 2007-06-01 at 12:47 -0500, Matthew Fredrickson wrote:
>
> > My question is this: is there a way to either work around the problem I
> > am seeing with the stack without recompiling the kernel with 8K stack
> > size or without disabling irqs for such a long period of time (which I
> > think is not a nice thing to do either) OR is it acceptable (although
> > not nice) to simply fix it this way, by disabling irqs while it loads
> > the firmware?
>
> I wonder if you're chasing ghosts; 4K stack kernels have a seperate
> stack for interrupts so... those should be safe.

Argh, yes, thanks for reminding/correcting all of us :-)

> Btw, you forgot to post a pointer to the source code of your driver, so
> it's a lot harder for us (read: impossible) to give you good advice..

Right, and dmesg / debug output of when things go wrong is also
needed at the very least to confirm whether or not there is really a
stack overflow issue here in the first place.

Satyam
