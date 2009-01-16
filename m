Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbZAPPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbZAPPZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935975AbZAPPYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:24:44 -0500
Received: from kroah.org ([198.145.64.141]:39876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935940AbZAPPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:24:42 -0500
Date: Fri, 16 Jan 2009 07:23:38 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Trilok Soni <soni.trilok@gmail.com>,
       Arve Hj?nnev?g <arve@android.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090116152338.GB9357@kroah.com>
References: <20090114104307.GA20451@elf.ucw.cz> <20090114104834.18387fca@lxorguk.ukuu.org.uk> <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com> <20090114231739.GB24111@kroah.com> <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com> <20090115001224.GC11328@kroah.com> <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com> <20090115234404.GA20142@kroah.com> <20090116090210.GB7039@linux-sh.org> <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 08:16:51PM +0900, KOSAKI Motohiro wrote:
> 
> As far as I know, embedded guys strong want to lowmem notification mecanism.

I think the big server guys also want the same thing :)

> At least, I and my mem_notify receive multiple contact from embedded
> and JavaVM developer.
>  (include sun javavm engineer)
> 
> In ideal, I think linux MM should care this requirement directly.

I agree.

> LSM and driver notifier is easy breakable because these component
> deeply depend on MM.

Agreed.

> (eg, I developed /dev/mem_notify patch last year. but this patch don't
> work on 2.6.28 because split-lru patch series totally changed MM
> reclaim processing.)
> 
> Unfortunately, we don't have any consensus of memory notification requirement.
> various people have various requirement. so, if I can discuss it and
> we get consensus, I'm glad.

Care to work on your mem_notify patch again and bring it up to date?
That would be a good place to start working from, right?

thanks,

greg k-h
