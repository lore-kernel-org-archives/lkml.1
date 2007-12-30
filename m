Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbXL3SkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbXL3SkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXL3Sjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:39:42 -0500
Received: from ns1.suse.de ([195.135.220.2]:60630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbXL3Sjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:39:40 -0500
To: "Russell Leidich" <rml@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
From: Andi Kleen <andi@firstfloor.org>
References: <20071217185453.C4597CC562@localhost>
	<20071225140413.e8b4f2cd.akpm@linux-foundation.org>
	<3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
	<20071227233419.d1adf3f3.akpm@linux-foundation.org>
	<3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
Date: Sun, 30 Dec 2007 19:39:39 +0100
In-Reply-To: <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com> (Russell Leidich's message of "Fri\, 28 Dec 2007 12\:40\:28 -0800")
Message-ID: <p731w9410yc.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Russell Leidich" <rml@google.com> writes:

Not sure you have addressed any of my feedback; don't see many changes.

When you repost stuff can you please add a changelog or if you decide
to not address some review comment say why at least.

Also the patch changelog description is missing anyways?

Biggest issue I raised is still not addressed:

> +	/*
> +	 * If any of the northbridges has PCI ID 0x1103, then its thermal
> +	 * hardware suffers from an erratum which prevents this code from
> +	 * working, so abort.
> +	 */
> +	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
> +		if ((k8_northbridges[nb_num]->device) == 0x1103)
> +			goto out;
> +	}

AFAIK that's all K8s so the code will never work on them. 

-Andi
