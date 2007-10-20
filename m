Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbXJUC3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbXJUC3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXJUC3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:29:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:14752 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXJUC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:29:32 -0400
Message-ID: <9783dadb0710201352p28969b4bs573d817d70b1fff7@mail.gmail.com>
Date: Sat, 20 Oct 2007 22:52:05 +0200
From: "David Gaarenstroom" <david.gaarenstroom@gmail.com>
To: "Shane Huang" <chunhao.huang@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
Cc: "Linas Vepstas" <linas@austin.ibm.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       jgarzik@pobox.com
In-Reply-To: <BLU120-W12C06900EC932864CC13A8E2980@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
	 <20071019195749.GK29903@austin.ibm.com>
	 <BLU120-W12C06900EC932864CC13A8E2980@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the pci_intx change will be applied to the SATA driver, can it be
applied for the ATI USB-HCDs too? See
http://lkml.org/lkml/2006/12/21/47 for more details. That should help
most of the ATI MSI quirks. It helped me (Acer Aspire 502x laptop with
ATI RS480/SB400).


> When I used "here", I was just meaning our youthful linux southbridge
> drivers team instead of the whole AMD. Sorry for the confusion to you.

I am still somewhat confused: most people developing the Linux kernel
are limited to look at this hardware from the outside. They had to
find out by trial and error. I really hope your colleagues will be
more actively helping your team and (other) Linux kernel developers.
But I'm glad AMD has such a team.
(So while you're at it, ask about the ATI USB HCDs and any other MSI quirk too)
