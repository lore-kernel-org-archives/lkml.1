Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZBDOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZBDOWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZBDOU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:20:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59320 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZBDOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:20:25 -0500
Date: Wed, 4 Feb 2009 14:20:15 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090204142015.GB3923@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com> <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain> <20090204060513.GA28321@srcf.ucam.org> <498953DF.5050306@redhat.com> <20090204131708.GA2739@srcf.ucam.org> <20090204142606.1823661b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204142606.1823661b@hyperion.delvare>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 02:26:06PM +0100, Jean Delvare wrote:
> On Wed, 4 Feb 2009 13:17:09 +0000, Matthew Garrett wrote:
> > Personally, I'd rather that it was "strict" on everything. We might 
> > break some existing setups, but they're already working mostly by luck.
> 
> Are you the new hwmon and i2c subsystems maintainer and I wasn't aware
> of it?

If you've got some programmatic way to tell the difference between safe 
and dangerous reuse of ACPI resources then that would obviously be 
preferable, but I doubt that's practical. auto is a compromise that 
avoids one specific case of breakage, but it does nothing to protect us 
on the majority of systems. Allowing the firmware and the OS to attempt 
to access the same hardware without any locking is an invitation for 
disaster, and in the absence of any way to prevent the firmware from 
doing it...

But. Hans asked for my opinion - the maintainer's is obviously more 
relevant.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
