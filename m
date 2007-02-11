Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbXBKXdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbXBKXdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbXBKXdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:33:10 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:34446 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbXBKXdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:33:08 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
In-Reply-To: <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>
	 <20070211064636.GA12171@1wt.eu>
	 <1171234027.4493.88.camel@nigel.suspend2.net>
	 <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com>
	 <1171236000.4493.116.camel@nigel.suspend2.net>
	 <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:33:06 +1100
Message-Id: <1171236787.4493.132.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 03:25 +0400, Manu Abraham wrote:
> On 2/12/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > Hi.
> >
> > On Mon, 2007-02-12 at 02:57 +0400, Manu Abraham wrote:
> > > On 2/12/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > >
> > > > Neither am I. I'm just asking that new drivers have power management as
> > > > standard.
> >
> > > What if the hardware doesn't support power management ?
> >
> > You would still want to do the cleanup and configuration that you'd do
> > for module load/unload.
> >
> By adding dummy functions, wouldn't that just look awkward ?

If all you need to do is say 'I don't need to do anything' and we have a
shared function that does that, all we're talking about doing is adding
to your struct pci_device (or whatever)

.resume = generic_empty_resume;

To me at least, that doesn't look awkward, and says cleanly and clearly
that you've checked things over and decided you know what's required.

Regards,

Nigel

