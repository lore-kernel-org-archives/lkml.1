Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZDCBUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZDCBUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbZDCBUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:20:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51404 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854AbZDCBUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:20:02 -0400
Date: Fri, 3 Apr 2009 02:19:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403011953.GA10777@srcf.ucam.org>
References: <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 06:16:20PM -0700, david@lang.hm wrote:
> On Fri, 3 Apr 2009, Matthew Garrett wrote:
> 
> >On Thu, Apr 02, 2009 at 05:55:11PM -0700, david@lang.hm wrote:
> >>On Fri, 3 Apr 2009, Matthew Garrett wrote:
> >>>Then they shouldn't use a mail client that fsync()s.
> >>
> >>so they need to use one mail client when they want to have good battery
> >>life and a different one when they are plugged in to power?
> >
> >They need to make a decision about whether they care about their mailbox
> >being precisely in sync with their server or not, and either use a
> >client that adapts appropriately or choose a client that behaves
> >appropriately. It's certainly not the kernel's business.
> 
> the kernel is not deciding this, the kernel would be implementing the 
> user's choice

No it wouldn't. The kernel would be implementing an adminstrator's 
choice about whether fsync() is important or not. That's something that 
would affect the mail client, but it's hardly a decision based on the 
mail client. Sucks to be that user if they do anything involving mysql.

> >If you can demonstrate a real world use case where the hard drive
> >(typically well under a watt of power consumption on modern systems)
> >spindown policy will be affected sufficiently pathologically by a mail
> >client that you lose an hour of battery life, then I'd rethink this. But
> >mostly I'd conclude that this was an example of an inappropriate
> >spindown policy.
> 
> remember that the mail client was an example.
> 
> you want another example, think of anything that uses sqlite (like the 
> firefox history stuff, although that was weakened drasticly due to the 
> ext3 problems).

Benchmarks please.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
