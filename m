Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbXKXEFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbXKXEFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXKXEF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:05:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:54825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXKXEF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:05:26 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mats Johannesson <spamcan@abcbredband.net>
Subject: Re: Laptop keyboard unusable when ACPI is active
Date: Fri, 23 Nov 2007 23:04:56 -0500
User-Agent: KMail/1.9.5
Cc: pavel@suse.cz, legolas558@users.sourceforge.net, dmitry.torokhov@gmail.com,
       astarikovskiy@suse.de, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20071123084443.2cf6b61e@loke.fish.not>
In-Reply-To: <20071123084443.2cf6b61e@loke.fish.not>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711232304.57652.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2007 02:44, Mats Johannesson wrote:

> The bad interaction between ACPI controlled EC (embedded controller)
> and the i8042 interrupt handler is theorized about in detail at OLPCs
> http://dev.laptop.org/ticket/2401 - almost at the end of that page.
> Thanks to Daniele C for the link.

huh?

I believe that the OLPC XO1 does not run in ACPI mode
and thus does not use the ACPI EC driver to talk to
the EC on their board.

Presumably they use some native embedded controller driver to
talk to their platform specific embedded controller.

I don't know why they call their interrupt an SCI.
Per above, it can't be an ACPI SCI.  Presumably they
call it that b/c their chipset documentation calls it
that too, on the (invalid) assumption that an ACPI-enabled
OS and firmware would be running on the hardware.

Please let me know if I'm wrong.

-Len
