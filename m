Return-Path: <linux-kernel-owner+w=401wt.eu-S934231AbXCVUmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbXCVUmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 16:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934235AbXCVUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 16:42:13 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:43625 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231AbXCVUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 16:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pQr9vUvNcPyx1253As9x9GJPSfd/9CVBcvufswdYr52tq5Ru78msgv2D5niM4eJ63k9Z9zUdu3Vuv3TyS1TgeeXcIGzgnVKILniq7ktyLTg7MxHMJJSpC4LwZp1z35TaGgtaR8iEcgMwq1v33iP352K9n3i+lYON3sZ6Dgza38w=
Message-ID: <b93822910703221342la530b1p987ae8c3b6948185@mail.gmail.com>
Date: Thu, 22 Mar 2007 21:42:09 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi quirk
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>, "john stultz" <johnstul@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070321151250.M95929@chilan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211137.10884.ak@suse.de>
	 <1174475666.10840.44.camel@localhost.localdomain>
	 <200703211342.59093.ak@suse.de>
	 <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
	 <1174486483.10840.89.camel@localhost.localdomain>
	 <20070321140930.GA5717@elte.hu> <20070321151250.M95929@chilan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/21, Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>:
> On Wed, 21 Mar 2007 15:09:30 +0100, Ingo Molnar wrote
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > > The local APIC timer stops to work in deeper C-States. This is handled
> > > by the ACPI code and a broadcast mechanism in the clockevents / tick
> > > managment code.
> > >
> > > Some systems do not expose the deeper C-States to the kernel, but
> > > switch into deeper C-States behind the kernels back. This delays the
> > > local apic timer interrupts for ever and makes the systems unusable.
> > >
> > > Add a command line option to disable the local apic timer and a dmi
> > > quirk for known broken systems.
>
> Confirming that my machine on 2.6-git with this patch works just like on
> 2.6.20. Great work.
>
> --
> Greetings - Grzegorz Chwesewicz

Works here too, thx ;)

Kind regards,
Stefan Prechtel
