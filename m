Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZESJLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZESJLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZESJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:11:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZESJLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:11:32 -0400
Date: Tue, 19 May 2009 11:11:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: 2.6.30-rc4: microcode: failed to init CPU1
Message-ID: <20090519091111.GA31404@elte.hu>
References: <1242588528.4814.6.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242588528.4814.6.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 
> >> [ ... ]
> >> [ 6643.982900] microcode: failed to init CPU1
> >> [ 6643.983528] CPU1 is up
> >> [ 6643.984529] ACPI: Waking up from system sleep state S4
> >> [ 6644.290917] pci 0000:00:1e.0: power state changed by ACPI to D0
> >> [ 6644.291103] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
> >> [ 6644.291139] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
> >> [ 6644.291187] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
> >> [ 6644.297593] pci 0000:00:07.0: PME# disabled
> >>
> >> Is this an error/problem?
> >
> > Not sure.
> >
> > CCing the people who have worked with the Intel microcode code recently.
> 
> 
> does the error message disappear with the following patch applied?
> 
> Thanks in advance.
> 
> 
> ---
> 
> 
> Subject: error handling inconsistency
> 
> Don't report an error in case there is simply no cached microcode 
> update available when resuming.
> 
> p.s. the current version in -tip provides better error handling 
> and doesn't have this problem.
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

We can do your fixlet for .30 as well (if it's tested by Thomas to 
solve the problem) - the reworked code in -tip is invasive changes 
aimed at .31.

	Ingo
