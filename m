Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbYGBLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbYGBLzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYGBLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:55:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59621 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGBLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:55:31 -0400
Date: Wed, 2 Jul 2008 12:55:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Justin Mattock <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: dsdt buggy acpi
Message-ID: <20080702115527.GA3396@srcf.ucam.org>
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com> <200807011619.53339.rjw@sisk.pl> <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com> <20080702082555.0959ef2b@linux360.ro> <20080702100935.GA699@srcf.ucam.org> <20080702144820.29f7d43d@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702144820.29f7d43d@linux360.ro>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 02:48:20PM +0300, Eduard - Gabriel Munteanu wrote:
> On Wed, 2 Jul 2008 11:09:35 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > We've made a huge number of workarounds for buggy DSDT
> > implementations.
> 
> Of course, I myself used a custom DSDT for my laptop. But I was saying
> that these workarounds generally do not belong to the kernel realm.

Of course they do. Nothing else is going to fix them up.

> This isn't the regular "Pentium F00F bug" stuff; instead bugs in DSDTs
> consist of compiling issues, non-standard compliant, plainly bad
> code, Windows-only stuff, which can all be unique for every model of a
> laptop for example. While the kernel may be able to get around some of
> that stuff, the kernel won't have any Asus, Acer etc. specific
> workarounds.

Windows doesn't have any Asus/Acer/whatever workarounds either. We just 
need to be compatible with the Windows implementation. There's a 
minority of cases where that isn't good enough, but almost every DSDT 
issue can (and should) be handled by Linux if the machine works under 
Windows.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
