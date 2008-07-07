Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYGGMci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYGGMci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYGGMc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:32:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbYGGMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:32:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 14:34:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <ac8af0be0807062054nbced6b0pd378aeda91a3c538@mail.gmail.com>
In-Reply-To: <ac8af0be0807062054nbced6b0pd378aeda91a3c538@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071434.10754.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Zhao Forrest wrote:
> > Hello,
> >
> >  Matthew, you have not added your sign-off with the original patch, please
> > do so now.
> >
> >  Rafael, please try this change together with
> > patch-2.6.26-rc1-20080505-mpparse-acpi-noirq0-2 and see if this fixes your
> > system.
> >
> >  I have tried the patches with a wildcard entry added to acpi_dmi_table[]
> > so that it trips for my system.  The result is as follows:
> 
> Since we add a new entry to acpi_dmi_table[], I think it's necessary
> for this new entry to preserve the semantics of this table, that is
> "acpi=force overrules DMI blacklist", am I right?

Can you please elaborate?

What exactly are we supposed to do apart from adding the new entries to the
table?

Thanks,
Rafael
