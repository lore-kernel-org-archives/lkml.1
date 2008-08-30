Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYH3Mrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYH3Mrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 08:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYH3MrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 08:47:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44553 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYH3MrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 08:47:21 -0400
Date: Sat, 30 Aug 2008 13:47:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Message-ID: <20080830124713.GA5910@srcf.ucam.org>
References: <200807241732.23412.trenn@suse.de> <200808281416.57193.trenn@suse.de> <20080828122227.GA26285@srcf.ucam.org> <200808291729.53628.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808291729.53628.trenn@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 05:29:52PM +0200, Thomas Renninger wrote:
> On Thursday 28 August 2008 14:22:29 Matthew Garrett wrote:
> > Little. But what advantage do we get in the same functionality being
> > implemented in an entirely custom way? Even less.
> It is all about documentation, right.
> WMI is complicating things by one needless and complicated layer.

Not really. It provides approximately no complexity for Linux drivers, 
and makes it easier for vendors to provide Windows support. WMI has not 
been the hard bit of the drivers I've written. I don't see any reason to 
ask vendors not to use it, as long as they're willing to document their 
implementation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
