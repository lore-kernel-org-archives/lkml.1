Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXKCI2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXKCI2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 04:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXKCI20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 04:28:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbXKCI2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 04:28:25 -0400
Date: Sat, 3 Nov 2007 09:28:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>
Subject: Re: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
Message-ID: <20071103082808.GB10760@elte.hu>
References: <472B5C01.7090508@m3y3r.de> <20071103063520.13EA59AFABF@smtp05.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103063520.13EA59AFABF@smtp05.mtu.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> > # CONFIG_ACPI_PROCFS is not set
> 
> And if you enable it (ACPI_PROCFS)?

ACPI_PROCFS was newly introduced i think but without a 'default y' 
Kconfig entry. That was a mistake i think - it broke some power 
management tools on my laptop too.

	Ingo
