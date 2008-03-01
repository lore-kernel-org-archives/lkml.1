Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYCAXuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYCAXuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 18:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYCAXtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 18:49:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:49625 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYCAXtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 18:49:51 -0500
Subject: Re: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jarod Wilson <jwilson@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linuxppc-dev@ozlabs.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47C9B1D3.3020402@redhat.com>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
	 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>  <47C9B1D3.3020402@redhat.com>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 10:48:24 +1100
Message-Id: <1204415304.15052.464.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-01 at 14:43 -0500, Jarod Wilson wrote:
> Stefan Richter wrote:
> > Copied from ohci1394.c.  This code is necessary to prevent machine check
> > exceptions when reloading or resuming the driver.
> > 
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> I was able to reproduce the system exception on resume with a 3rd-gen 
> Titanium PowerBook G4 667, and this patch does let the system resume 
> successfully now.
> 
> Not quite clear if there was possibly an updated version coming using 
> pci_enable_device() instead of the pair of pmac_call_feature() calls, 
> but either way, this is a definite must-have, at least for older ppc 
> macs -- my Aluminum PowerBook G4/1.67 suspends and resumes without this 
> patch just fine.

Let's go with Stefan patch for now. I'll find out what's up with
pci_enable_device() later.

Ben.


