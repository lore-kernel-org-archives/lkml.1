Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYI2TOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYI2TOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYI2TN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:13:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbYI2TN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:13:58 -0400
Date: Mon, 29 Sep 2008 12:13:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <48E11EFA.8010402@keyaccess.nl>
Message-ID: <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Sep 2008, Rene Herman wrote:
> 
> I believe the possible issue is that resources that do _not_ (seem to) start
> at zero might also be disabled.

But that is irrelevant.

If we have registered them in the resource tree, then PnP must ignore 
them.

The fact is, this is not about being enabled or disabled. This is about 
the PnP tree containing resources that we already parsed from the PCI 
stuff, and once we've seen them as PCI resources, there's not really 
anything valuable in the PnP information.

			Linus
