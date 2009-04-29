Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZD2Os7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZD2Os7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZD2Osq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:48:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZD2Oso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:48:44 -0400
Date: Wed, 29 Apr 2009 16:48:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090429144818.GA9716@elte.hu>
References: <20090415225348.GW8311@plum> <200904201113.31371.trenn@suse.de> <20090420104529.GB6670@elte.hu> <200904291519.29683.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904291519.29683.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Thomas Renninger <trenn@suse.de> wrote:

> On Monday 20 April 2009 12:45:29 Ingo Molnar wrote:
> > 
> > * Thomas Renninger <trenn@suse.de> wrote:
> > 
> > > On Monday 20 April 2009 07:13:51 Len Brown wrote:
> > > > FYI,
> > > > Thanks to Ebay, I now have a T60:-)
> > > Hmm, Lenovo sold a lot different machines as T60.
> > > I found an acpidump of a T60 here without any _PPC function
> > > at all.
> > > 
> > > > and so i put the DSDT here:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=13139
> > > > 
> > > > I'll poke at this in more detail soon...
> > > Ingo, can you place yours somewhere too, please.
> > > This one should be taken into account for _PPC code changes
> > > as it seem to implement some corner case.
> > 
> > Sure, find it attached below.
> > 
> > 	Ingo
> > 
> > DSDT @ 0x7f6e65e7
> >   0000: 44 53 44 54 65 c7 00 00 01 49 4c 45 4e 4f 56 4f  
> ...
> Ingo, did you do a BIOS update in between?
> The DSDT and SSDTs you added do not contain a _PPC function.
> These ACPI tables definitely do not suffer from an initial _PPC
> evaluation.

no, i didnt update anything. I only touch the BIOS if i absolutely 
have to. Was the original analysis wrong then?

	Ingo
