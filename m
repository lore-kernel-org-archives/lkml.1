Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYGFXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYGFXAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYGFXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:00:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYGFXAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:00:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 01:02:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807012158.34356.rjw@sisk.pl> <20080701202453.GD4896@elte.hu>
In-Reply-To: <20080701202453.GD4896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807070102.38854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> > > 
> > > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > 
> > > > Assuming it works for Rafael (still haven't had time to pull my nx6125 
> > > > out of storage):
> > > > 
> > > > Signed-off-by: mjg@redhat.com
> > > 
> > > Rafael, could you please try the latest tip/master that i've just pushed 
> > > out:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > it has the final form of these changes integrated - it should in 
> > > theory work out of box on your system, with no boot parameters or 
> > > other explicit quirks needed anywhere.
> > 
> > I tested patches [1/2] (your version) and [2/2] on top of today's 
> > linux-next and they work just fine.
> 
> thanks Rafael!

Well, I'm afraid that my information wasn't correct.  The patches actually
don't work, but I had my own additional patch that fixed the problem applied,
which I've only just discovered.  Sorry for the confusion and the issue is
still unfixed.

Thanks,
Rafael
