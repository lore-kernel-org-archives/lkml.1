Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYH1MRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYH1MRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYH1MRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:17:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:55444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYH1MRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:17:05 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Thu, 28 Aug 2008 14:16:55 +0200
User-Agent: KMail/1.9.9
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <200808281141.30178.trenn@suse.de> <20080828105616.GA24515@srcf.ucam.org>
In-Reply-To: <20080828105616.GA24515@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281416.57193.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 12:56:16 Matthew Garrett wrote:
> On Thu, Aug 28, 2008 at 11:41:28AM +0200, Thomas Renninger wrote:
> > On Wednesday 27 August 2008 22:29:15 Carlos Corbacho wrote:
> > > Perhaps it would be more useful to suggest to vendors/ BIOS writers
> > > what they should use here instead?
> >
> > They can use their own devices.
> > There is a section about if you provide your own device, document it,
> > etc.:
> >
> > 2 Vendor specific ACPI implementations
> > ...
> > 2. If new devices or functions are introduced, document how to use them.
> > A short specification or a request for comments (RFC) can form the basis
> > of a new standard which follows your needs.
> >
> >
> > But yes, it could be pointed out clearer.
> > I'll look closer at it when I touch it the next time.
> > Text snippets/suggestions are also appreciated.
>
> A documented WMI interface is easier to use than an entirely custom 
> documented interface, and reduces the amount of work the vendor has to
> do in Windows. To be honest, I think it's the sort of thing we should be
> encouraging.
IMO WMI should not exist.
A lot laptop BIOSes do not use it at all, unfortunately it seems to get
more common again.
What advantage do you get on Linux using WMI?

For example HP is using WMI to export a WLAN (or bluetooth?) button on
some machines.
They should not do that, right?

AFAIK most vendors tend to send an ordinary key event again for most
extra buttons. Is this the way to go for the future? This probably
should also be mentioned then.

    Thomas
