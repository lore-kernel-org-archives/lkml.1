Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZDTWSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZDTWSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZDTWSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:18:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51005 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbZDTWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:18:40 -0400
X-Sasl-enc: zFDAaurr1K6I5m+S4njS2c46TV8qwYJrVRT4ubzDxmpZ 1240265919
Date: Mon, 20 Apr 2009 19:18:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090420221836.GF25823@khazad-dum.debian.net>
References: <20090415225348.GW8311@plum> <20090416224507.GA31984@srcf.ucam.org> <alpine.LFD.2.00.0904200112290.10996@localhost.localdomain> <200904201113.31371.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904201113.31371.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Thomas Renninger wrote:
> On Monday 20 April 2009 07:13:51 Len Brown wrote:
> > FYI,
> > Thanks to Ebay, I now have a T60:-)
> Hmm, Lenovo sold a lot different machines as T60.

There are only two types as far as the firmware is concerned: widescreen and
non-widescreen.

However, the older BIOS (non-widescreen) had a major version bump, so
machines with outdated firmware can have quite a different BIOS.

> I found an acpidump of a T60 here without any _PPC function
> at all.
> 
> > and so i put the DSDT here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13139
> > 
> > I'll poke at this in more detail soon...
> Ingo, can you place yours somewhere too, please.
> This one should be taken into account for _PPC code changes
> as it seem to implement some corner case.

It is probably worth upgrading the T60 after you got all the relevant
information (dmidecode, full acpidump), and check again with the latest
firmware.

Here are the links with instructions:
http://www.thinkwiki.org/wiki/BIOS_Upgrade

and a table of links for the firmware itself (get the CD versions to flash
without Windows):
http://www.thinkwiki.org/wiki/BIOS_Upgrade_Downloads#T_Series

Also, if you guys do collect that info (dmidecode, full acpidump), I'd
appreciate if you could send them my way in private.  They often prove
useful for thinkpad-acpi work...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
