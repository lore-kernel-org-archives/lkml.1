Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbXJ2NVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbXJ2NVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJ2NVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:21:08 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:44516 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXJ2NVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:21:06 -0400
Date: Mon, 29 Oct 2007 13:11:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
Message-ID: <20071029131159.GA27283@srcf.ucam.org>
References: <1193236319.4590.225.camel@queen.suse.de> <200710250906.23003.bjorn.helgaas@hp.com> <20071027150947.GA1568@srcf.ucam.org> <200710282050.34166.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710282050.34166.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 08:50:33PM -0600, Bjorn Helgaas wrote:
> On Saturday 27 October 2007 9:09:47 am Matthew Garrett wrote:
> > On Thu, Oct 25, 2007 at 09:06:22AM -0600, Bjorn Helgaas wrote:
> > > But we really *should* reserve things used by opregions, shouldn't
> > > we?  After all, the whole point of resource reservation is to prevent
> > > conflicts.
> >
> > Only if you're happy to lose functionality like IDE, sadly.
> 
> That's a simplistic answer to a complex problem.  I don't think
> we should just ignore the whole problem, cross our fingers, and
> hope that firmware stays out of our way.

Right now, there's not really any other way of handling it. The firmware 
may screw with pretty much everything, and it might even be safe for it 
to do so in many cases. In any case, you don't necessarily win that much 
by registering all the opregions, since SMI can go behind your back and 
write to stuff that's not declared in the DSDT anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
