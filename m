Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZFSMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZFSMhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZFSMhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:37:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54634 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFSMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:37:38 -0400
Date: Fri, 19 Jun 2009 13:37:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>, yanli@infradead.org
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090619123738.GA21094@srcf.ucam.org>
References: <20090616154200.GA12715@srcf.ucam.org> <20090616173618.353901ee@lxorguk.ukuu.org.uk> <20090616164351.GA14353@srcf.ucam.org> <20090616181549.496ae0f2@lxorguk.ukuu.org.uk> <20090616171732.GA14912@srcf.ucam.org> <20090617010138.GA13479@thyme.bj.intel.com> <20090617025101.GA27595@srcf.ucam.org> <20090618000809.GB16835@thyme.bj.intel.com> <20090618154250.GA30209@srcf.ucam.org> <20090619071634.GA7671@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619071634.GA7671@thyme.bj.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:16:55PM +0800, Li, Yan I wrote:

> Not necessarily if we had followed the spec (I'm not sure of this) of
> using i8042.

The spec is irrelevant. What matters is what's implemented. Canonical 
found a case where our i8042 setup code varied from Windows and which 
fixed some hardware. Our ACPI implementation deviates wildly from the 
spec in some places because that's what the implemented platforms 
expect. The kernel exists to drive hardware, not adhere to some platonic 
ideal of how the hardware should behave.

> Hope someone can help us do this test.  I have already found loads of
> touchpad drivers on net so I guess Windows can't drive a touchpad
> until a driver is installed.  Pure guess.

Touchpads typically present as a PS/2 mouse until a specific driver is 
loaded, at which point they switch to a protocol that provides absolute 
cooirdinates and pressure. It would be virtually impossible to install 
most operating systems otherwise.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
