Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYLJQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYLJQFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYLJQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:05:24 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:55124 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739AbYLJQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:05:22 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume (was: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
Date: Wed, 10 Dec 2008 17:05:17 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812101506.45691.elendil@planet.nl> <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101705.18899.elendil@planet.nl>
X-OriginalArrivalTime: 10 Dec 2008 16:05:19.0509 (UTC) FILETIME=[19487450:01C95AE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008, Linus Torvalds wrote:
> On Wed, 10 Dec 2008, Frans Pop wrote:
> > Anybody interested in persuing this issue?
> >
> > > The third thing that worries me is the _very_ early occurrence of
> > >
> > > 	ACPI: Waking up from system sleep state S3
> > > 	APIC error on CPU1: 00(40)
> > > 	ACPI: EC: non-query interrupt received, switching to interrupt
> > > mode
>
> Well, the "too early" part is fixed with the PCI resume changes in
> -next, and googling for "APIC error on CPU1: 00(40)" shows that it's
> actually pretty common. Which is sad, but makes it somewhat less scary.
>
> The fact that it happens at resume for you (and not randomly) does
> imply that we perhaps don't have a wonderful APIC wakeup sequence and
> are doing something slightly wrong. But it likely isn't a big deal.
>
> Is that message new? If it is, maybe you can pinpoint roughly when it
> started happening, and we could try guess which change triggered it.

It's been there since 2.6.26.3, which was the first kernel I've run on 
this notebook.
