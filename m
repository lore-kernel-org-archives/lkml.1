Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYLJJxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYLJJxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYLJJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:53:23 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58100 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbYLJJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:53:21 -0500
X-Sasl-enc: fUAoQZ5B8OSCme2gc6GblVrl7K/C8tDszLyPGSeWzV5D 1228902799
Date: Wed, 10 Dec 2008 07:53:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <abelay@mit.edu>,
       rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
Message-ID: <20081210095315.GA20627@khazad-dum.debian.net>
References: <493D8A1F.2090907@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493D8A1F.2090907@gmx.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2008, Witold Szczeponik wrote:
> This patch sets the power of PnP ACPI devices to D0 when they
> are activated and to D3 when they are disabled.  The latter is

This will likely fix my T43 to power down USB during STR. THANKS!!
Now, I just need to check if the ACPI BIOS is smart enough to not do
it when they are configured as wake devices [in the BIOS].

Although I do wonder WTF we don't do that on our USB UHCI/EHCI kernel
drivers, that ACPI needs to step in to fix it.  If it is not a wake
device, why are we leaving it powered up?  It is bad enough we don't
have any sort of proper USB power control, but to leave the entire USB
subsystem powered up without reason?!

Vista not only powers down the USB HCIs and ports on STR, it also
powers down ports when you "safely remove the USB device", and seems
to leave the port powered down until you insert a device (or remove
the device already in there, whatever).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
