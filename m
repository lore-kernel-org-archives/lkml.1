Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbYCKXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbYCKXOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYCKXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:14:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:57513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbYCKXOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:14:08 -0400
Subject: Re: [patch 0/2] PNP: disable PNP motherboard resources that
	overlap PCI BARs
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Li Shaohua <shaohua.li@intel.com>,
       Matthew Hall <mhall@mhcomputing.net>, Willem Riede <wriede@riede.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Karl Bellve <karl.bellve@umassmed.edu>,
       Avuton Olrich <avuton@gmail.com>
In-Reply-To: <20080311212439.293001409@ldl.fc.hp.com>
References: <20080311212439.293001409@ldl.fc.hp.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Mar 2008 00:14:18 +0100
Message-Id: <1205277258.8194.13.camel@linux-2bdv.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-11 at 15:24 -0600, Bjorn Helgaas wrote:
> The following two patches fix several problems caused by BIOSes that
> report PNP motherboard device resources that overlap with PCI BARs.
> 
> I think these should go in before 2.6.25 because some of these problems
> showed up in 2.6.24 when we increased PNP_MAX_MEM from 4 to 12, and
> there's no good way to work around them.

﻿I cannot judge about the "cleanness" because of possible changes of
initialization time of pci/pnp or whatever.

I can confirm that ACPI resource declarations (especially (only?) in the
general motherboard devices) are ﻿often rather broken.
Therefore I like your general approach compared to the per machine dmi
match quirks. I expect the latter (dmi matching) is rather hopeless.


   Thomas

