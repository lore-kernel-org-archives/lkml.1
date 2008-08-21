Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbYHUPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbYHUPP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbYHUPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:15:12 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:22240 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYHUPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:15:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Thu, 21 Aug 2008 09:14:27 -0600
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200808181540.25286.elendil@planet.nl> <200808211440.27577.rjw@sisk.pl> <1219325336.20723.32.camel@lgn.site>
In-Reply-To: <1219325336.20723.32.camel@lgn.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210914.27516.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 07:28:56 am Kay Sievers wrote:
> Yeah, we miss to loop over the list. This should fix it. Thanks!

Thanks for the patch.

Can somebody elaborate on why we need to add "acpi*" aliases for all
PNP devices?  That broadens the kernel/user interface, so I'd like
to understand why we need it.

Bjorn

