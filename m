Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYCCWQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYCCWQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYCCWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:16:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:21375 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYCCWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:16:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4ht7puOMerEEIGD+/fpMOVxcv22LOXpA2T+uJSa7+uDGMUCcGmG3PVCjYv14h8MdffGT875LvEYgQMgAqS1mEs6DgUjMZi7EmxFbjraA+72OKLsa6yy6SvwqNXBCHzGsc93gQ62iRy2ZkSoaFTdL5aG3HX27oHbBfqF7XyIDk8=
Message-ID: <f19298770803031416y32dbb7dakfc88b8572c2c10fe@mail.gmail.com>
Date: Tue, 4 Mar 2008 01:16:22 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <20080303104559.GE21190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
	 <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu>
	 <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com>
	 <20080229194547.GC21249@elte.hu>
	 <f19298770802291642v56a8a50ve5c7c88de53513f4@mail.gmail.com>
	 <f19298770802291659x741c9fd9h3b3090fd514fe77b@mail.gmail.com>
	 <20080303104559.GE21190@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 1:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>
> > >  I"ll now recompile with fair group scheduler disabled, just to be
>  > >  sure.
>  >
>  > Yes, with the group scheduler disabled, the latencies for both Xorg
>  > and gnome-terminal do net exceed 15 ms. And the mouse is also smooth.
>
>  could you also try the current scheduler fixes lineup in
>  sched-devel.git:
>
>    http://people.redhat.com/mingo/sched-devel.git/README
>
>  is the mouse smooth with the group scheduler _enabled_ too?
>

Works fine. The latencies of both Xorg and gnome-terminal are
reported to be about 5-20 ms, and the mouse is smooth too.

Thanks for the fast response to the ptoblem.

>         Ingo
>
