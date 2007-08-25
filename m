Return-Path: <linux-kernel-owner+w=401wt.eu-S1764892AbXHYQpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764892AbXHYQpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXHYQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:44:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:18438 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761453AbXHYQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=epwIdN4X4diDNifCVOW2t/puT/MWgAsq8tbEqVMlfhK5lX4hU3e1iTZc+pUqDFfnatL4nTtVm+O0G469COqMS+FixBZ/EC2gB7LaBaOqZxF7RDQ+tLP+1EwOt07/aEspZ3XtKagajujjhMV5Nq13kOK5sYG4VC30tRxpQL6CQic=
Message-ID: <3c1737210708250944u7043c9e1j3be70674a1b55911@mail.gmail.com>
Date: Sat, 25 Aug 2007 18:44:40 +0200
From: "Michael Smith" <msmith@xiph.org>
To: "john stultz" <johnstul@us.ibm.com>
Subject: Re: gettimeofday() jumping into the future
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andy Wingo" <wingo@fluendo.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1187894822.6024.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
	 <1187869632.6114.368.camel@twins>
	 <3c1737210708230520l7dee896crc614f7fc60ac7a1a@mail.gmail.com>
	 <1187894822.6024.8.camel@localhost.localdomain>
X-Google-Sender-Auth: 9447366d6563c5c1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hmm. That does sound like unsycned TSCs. Normally Intel systems don't
> skew unless they are NUMA systems or you're entering low power states.
> We try to catch both of those cases, so I'm not sure how you box is
> slipping through.
>
> Can you run the following test to verify that the TSCs are skewed?

I ran this for the past two days, multiple copies to put some load on
the system (the initial problem with gettimeofday() was easier to
reproduce under load). Nothing.

So, I guess that rules out unsynced TSCs as the cause? Or perhaps it
only happens in other conditions, for some reason. I'm on holidays
right now, but my coworkers should be able to continue investigating
other possible causes.

Thanks for the advice/test program.

Mike
