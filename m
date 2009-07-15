Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZGOOBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZGOOBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZGOOBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:01:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42362 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZGOOBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:01:02 -0400
Date: Wed, 15 Jul 2009 15:00:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ykzhao <yakui.zhao@intel.com>
Cc: Crane Cai <crane.cai@amd.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: add driver for SMBus Control Method Interface
Message-ID: <20090715140057.GB19054@srcf.ucam.org>
References: <20090715060219.GA30514@crane-desktop> <1247651002.4113.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247651002.4113.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 05:43:22PM +0800, ykzhao wrote:
> On Wed, 2009-07-15 at 14:02 +0800, Crane Cai wrote:
> > This driver supports the SMBus Control Method Interface. It needs BIOS declare
> > ACPI control methods via SMBus Control Method Interface Spec.
> It seems that SM bus control is realized in BIOS. And OS can use the
> given control method interface to access it. 
> Will this controller be accessed directly directly BIOS?
> If it can be accessed by BIOS, how to resolve the conflict between BIOS
> and OS?

It's being accessed via ACPI methods, so the vendors have the 
opportunity to implement proper locking.

> In fact we see the conflict on some boxes. The SMbus controller will be
> accessed by BIOS. If the corresponding driver is loaded for the SMBUS
> controller, there exists the potential risk. In such case we will hide
> the SMbus controller or not load the device driver for it.

I don't think that's a risk in this case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
