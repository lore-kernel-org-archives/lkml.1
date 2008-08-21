Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYHUUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYHUUbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYHUUbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:31:25 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:13088 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbYHUUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:31:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Thu, 21 Aug 2008 22:30:50 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200808181540.25286.elendil@planet.nl> <200808211440.27577.rjw@sisk.pl> <1219325336.20723.32.camel@lgn.site>
In-Reply-To: <1219325336.20723.32.camel@lgn.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212230.51948.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2008 20:31:21.0208 (UTC) FILETIME=[DF582F80:01C903CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: pnp: fix "add acpi:* modalias entries"
>
> With 22454cb99fc39f2629ad06a7eccb3df312f8830e we added only the
> first entry of the device table. We need to loop over the whole
> device list.
>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

This patch works for me (tested on top of -rc4).

$ grep IFX /lib/modules/2.6.27-rc4/modules.alias
alias acpi*:IFX0102:* tpm_infineon
alias pnp:dIFX0102* tpm_infineon
alias acpi*:IFX0101:* tpm_infineon
alias pnp:dIFX0101* tpm_infineon

And the tpm modules are automatically loaded again.

Cheers,
FJP
