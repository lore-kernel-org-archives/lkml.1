Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXCUPOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXCUPOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXCUPOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:14:34 -0400
Received: from mail.chilan.com ([82.160.212.9]:56476 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbXCUPOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:14:33 -0400
From: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi quirk
Date: Wed, 21 Mar 2007 16:14:33 +0100
Message-Id: <20070321151250.M95929@chilan.com>
In-Reply-To: <20070321140930.GA5717@elte.hu>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <200703211137.10884.ak@suse.de> <1174475666.10840.44.camel@localhost.localdomain> <200703211342.59093.ak@suse.de> <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com> <1174486483.10840.89.camel@localhost.localdomain> <20070321140930.GA5717@elte.hu>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 82.160.213.5 (ceho)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 15:09:30 +0100, Ingo Molnar wrote
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The local APIC timer stops to work in deeper C-States. This is handled 
> > by the ACPI code and a broadcast mechanism in the clockevents / tick 
> > managment code.
> > 
> > Some systems do not expose the deeper C-States to the kernel, but 
> > switch into deeper C-States behind the kernels back. This delays the 
> > local apic timer interrupts for ever and makes the systems unusable.
> > 
> > Add a command line option to disable the local apic timer and a dmi 
> > quirk for known broken systems.

Confirming that my machine on 2.6-git with this patch works just like on
2.6.20. Great work.

--
Greetings - Grzegorz Chwesewicz

