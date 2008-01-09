Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYAIC2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYAIC2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYAIC2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:28:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYAIC2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:28:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=IxC8j4asrs6jupU2rQyL4Zde+AndV3bvZ+qWvH5j6axuxtAGQmoGmA0yweJDdCY/h
	jq91ynuEqnoeS2IV9PlJQ==
Message-ID: <3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com>
Date: Tue, 8 Jan 2008 18:28:18 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu,
       "Tim Hockin" <thockin@google.com>
In-Reply-To: <20080108235212.GE2117@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com>
	 <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
	 <20080102215433.GB13784@one.firstfloor.org>
	 <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com>
	 <20080104222637.GA19248@one.firstfloor.org>
	 <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
	 <20080105132402.GA705@one.firstfloor.org>
	 <3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com>
	 <3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com>
	 <20080108235212.GE2117@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 3:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >  ENTRY(thermal_interrupt)
> > -     apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
> > +     apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt(%rip)
>
> Are you sure a * is not needed?  I would have thought it would jump
> to the variable instead of through it. But if it works it's ok for me.

I will test to make sure it works.  I don't think stars mean anything
in AT&T-style X86-64.

>
> The rest of the patch looks ok to to me.

Thank you!  I will give it a final test and submit the official patch this week.

>
> -Andi
>
>



-- 
Russell Leidich
