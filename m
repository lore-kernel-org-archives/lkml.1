Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYHMN6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYHMN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYHMN6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:58:25 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35259 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYHMN6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:58:24 -0400
In-Reply-To: <20080812231602.GB12838@kroah.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFF057DDEC.475AAF27-ON852574A4.004BC636-852574A4.004CC1A3@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Wed, 13 Aug 2008 09:58:22 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/13/2008 09:58:21
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote on 08/12/2008 07:16:02 PM:

> On Tue, Aug 12, 2008 at 04:57:31PM -0400, Kenneth Goldman wrote:
> > Christoph Hellwig <hch@infradead.org> wrote on 08/12/2008 03:30:31 PM:
> >
> > > And what happens when the chip simply goes away due to a hotplug
action?
> > > Or not even the actual chip goes away but just the chip driver and
you
> > > now dereference freed memory?
> >
> > Being a TCG/TPM person, I can only address the first question.  The
> > intent is that the TPM is soldered to the planar/motherboard (the TCG
> > uses the phrase "bound to the platform").  I can't imagine
> > any manufacturer designing a pluggable TPM.  It would subvert PCR
> > measurements and thus attestation, data sealing, etc.
>
> Load up the fake-php hotplug pci driver and "soft" disconnect it from
> the system :)
>
> That was easy...
>
> Note, just because you think your device is always going to be soldered
> to the motherboard, doesn't mean it can't be disconnected at any point
> in time with the kernel running.
>
> Or the module could just be unloaded, that's also a very common thing to
> have happen, right?

As I said, I'm a TCG/TPM person, so I can't address "the module could just
be unloaded" or "hotplug pci driver".  I'll leave that issue to the
Linux driver experts.

I was using the common meaning of hotplug, removing and replacing a
hardware component while power is on.  By that common definition, the
TPM would not be a hotpluggable component.

(As an aside, the TPM is commonly connected to the LPC bus on
the planar, not the PCI bus.)

