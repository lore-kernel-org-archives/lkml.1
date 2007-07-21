Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbXGUC4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbXGUC4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 22:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbXGUC40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 22:56:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:40799 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXGUC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 22:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lsPe+RCc07vzas+iCBqvjNrRRToVwgNkIPTBk/5mO9vYuVtPReRjy6EGEX5xU2JW4z9tx1dnQ9aKOh0g76NR/0xY+lOm/4ZqNd72yGkPAmxO40HkZ/2KAm09p70liPzDuY0es9PvoBI1iUAH7v1sP7H8n6IWbNcxVl03IoI38Ng=
Message-ID: <86802c440707201956n6f3579e3g7eb807c6cd4c0d24@mail.gmail.com>
Date: Fri, 20 Jul 2007 19:56:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Cc: "Jeff Garzik" <jeff@garzik.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       "Andi Kleen" <ak@suse.de>, "Arjan van de Ven" <arjan@infradead.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20070720224033.GA12358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184970779.4012.38.camel@chaos> <46A1396F.4090204@garzik.org>
	 <20070720224033.GA12358@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeff Garzik <jeff@garzik.org> wrote:
>
> > I agree with Andi...  it's quite nice to be able to leave some
> > arch/i386 stuff, and not carry it over to arch/x86-64.
>
> we can leave those few items in arch/x86 just as much. No need to keep
> around a legacy tree for that.

how about making all files ans directories take _32 or _64 in the name?
except the files or dir that are shared.

for example: k8_bus.c is only need by 64 ===> change it to k8_bus_64.c
mach-generic===> mach-generic_32

YH
