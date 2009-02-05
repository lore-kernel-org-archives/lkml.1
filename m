Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZBEXnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZBEXnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZBEXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:43:37 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4892 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbZBEXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:43:36 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] floppy: request only the ports we actually use
Date: Thu, 5 Feb 2009 16:43:31 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, phdm@macqel.be, hancockrwd@gmail.com,
       abelay@mit.edu, lenb@kernel.org, stable@kernel.org
References: <20090205174859.18396.68512.stgit@bob.kio> <200902051055.34149.bjorn.helgaas@hp.com> <20090205142948.1a48d983.akpm@linux-foundation.org>
In-Reply-To: <20090205142948.1a48d983.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051643.32591.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 03:29:48 pm Andrew Morton wrote:
> On Thu, 5 Feb 2009 10:55:33 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Thursday 05 February 2009 10:48:59 am Bjorn Helgaas wrote:
> > > The floppy driver requests an I/O port it doesn't need, and
> > > sometimes this causes a conflict with a motherboard device
> > > reported by PNPBIOS.
> > > 
> > > This patch makes the floppy driver request only the ports it
> > > actually uses.
> > > ...
> > > Philippe reported that this conflict broke the floppy driver between
> > > 2.6.11 and 2.6.22.  ...
> > 
> > While this is old and BIOS-specific, it is a regression, so we might
> > consider it for 2.6.29.
> 
> And earlier, surely?

Sure, I'm OK with that.  I haven't heard any complaints, so maybe we
want it in -mm for a while before putting it in stable?

> I tagged it
> 
> Cc: <stable@kernel.org> [2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
> 
> (I'm not sure if 2.6.25.x is still being maintained by Greg & Chris,
> but other parties are maintaining 2.6.25-based kernels, and such
> tagging might help them).

