Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZBDGFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZBDGFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZBDGFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:05:25 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41414 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZBDGFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:05:24 -0500
Date: Wed, 4 Feb 2009 06:05:13 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans de Goede <hdegoede@redhat.com>, khali@linux-fr.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090204060513.GA28321@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com> <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 12:52:06AM -0500, Len Brown wrote:

> While it is slightly off-topic of the (I agree, real)
> technical issue here, note that polling is not "normal" on ACPI systems.
> [1] was on  SuSE Linux 10.0, which on their own decided to
> over-ride the kernel and enable thermal zone polling by default.

Checking the DSDTs I have to hand, it seems that polling is expected on 
about 5% of systems via an explicit _TZP and on almost all machines via 
_TSP. Even on systems where thermal notifications are provided, it's 
still up to the OS to poll the zone to find the current temperature and 
take appropriate action. There's still a window for native smbus drivers 
to screw everything up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
