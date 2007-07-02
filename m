Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXGBJ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXGBJ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXGBJ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:56:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:16913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXGBJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C6OFUVeGa9gkU2Fc0BFe0NX974hHlooxuWwUApBZYvkrquvJiLJZQSlHVzVmk1uYI8kApgXAr5yi4y3IQi34a3giqYXYWjNPxQYVrJ4vm4aSStNNZx+tMFh9VMh1Q5TCdRj7r+TONW/LZDDADmaEyfML75QyEi5piH1buN+3lg8=
Message-ID: <863e9df20707020256m75d24f52yfc5acd78cacffac7@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:26:12 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: instrumentation and kprobes really still "EXPERIMENTAL"?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
In-Reply-To: <Pine.LNX.4.64.0707020512320.26135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
	 <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com>
	 <Pine.LNX.4.64.0707020512320.26135@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Mon, 2 Jul 2007, Abhishek Sagar wrote:
>
> > On 7/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > isn't kprobes mature enough to not be considered experimental anymore?
> >
> > That would vary from arch to arch.
>
> fair enough.  however, at the very least, i'm thinking that the entire
> "Instrumentation support" submenu can be made non-EXPERIMENTAL, while
> individual entries therein can be EXPERIMENTAL on a choice-by-choice
> basis or something like that.

There's not a lot in that menu. It holds oprofile on every arch I
grepped on. Oprofile might come across as being marked
non-experimental but that may very well be due to the assumption that
the menu that holds that option will enforce the EXPERIMENTAL check.
How many archs do you see where oprofile and kprobe defer on their
dependency on EXPERIMENTAL?

Removing the EXPERIMENTAL check from the instrumentation menu will
also require you to fix/double-check dependency on EXPERIMENTAL of
oprofile/kprobes, provided you know that for sure. Which would bring
you back to the same question you began with, namely, whether option
xyz is EXPERIMENTAL or not.

--
Abhishek Sagar
-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
