Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZBJQYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZBJQYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZBJQY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:24:29 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13479 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZBJQY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:24:28 -0500
Date: Tue, 10 Feb 2009 17:24:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090210172408.400cacee@hyperion.delvare>
In-Reply-To: <49919E08.5050002@redhat.com>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291130.35434.trenn@suse.de>
	<68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
	<alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
	<20090204060513.GA28321@srcf.ucam.org>
	<498953DF.5050306@redhat.com>
	<20090204131708.GA2739@srcf.ucam.org>
	<20090204142606.1823661b@hyperion.delvare>
	<20090204142015.GB3923@srcf.ucam.org>
	<20090210145716.105ab58b@hyperion.delvare>
	<20090210140829.GA25397@srcf.ucam.org>
	<49919E08.5050002@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 16:32:24 +0100, Hans de Goede wrote:
> Matthew Garrett wrote:
> > On Tue, Feb 10, 2009 at 02:57:16PM +0100, Jean Delvare wrote:
> > 
>   year (I think the info is available, right?) We could
> >> default to strict for systems with year >= 2009. This may still prevent
> >> users from getting the best out of their system, but at least won't
> >> cause a regression for users of older systems where the native driver
> >> has been used so far. I know it's not an ideal solution, but ACPI
> >> implementations aren't ideal either.
> > 
> > The problem with this approach is that we still end up with a large 
> > number of malfunctioning machines. Really, I don't think there's any way 
> > to handle this other than defaulting to strict, letting the default be 
> > changed at run and boot time and printing a message when a driver is 
> > refused permission to bind. Distributions that want to obtain the 
> > previous behaviour can change the default back.

If we expect different distributions / user classes to set a different
default, then it might make sense to make acpi_enforce_resources's
default value a config option?

> For the record we have changed the default to strict in Fedora's 
> development branch, for 2 weeks or so now, including in the recently 
> released Fedora 11 release and we've had 0 complaints so far.

Well, if the number of affected systems is small, this is good news.
But this is only 2 weeks and one distribution, coverage isn't
sufficient to claim anything yet IMHO.

That being said... if there's a common consensus that switching to
strict and dealing with fallouts is the best thing to do, and I'm the
only one objecting to this, then I am ready to admit that I was wrong
and let you proceed.

-- 
Jean Delvare
