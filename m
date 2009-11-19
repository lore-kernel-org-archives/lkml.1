Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZKSSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZKSSIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZKSSIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:08:00 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:25807 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZKSSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:07:59 -0500
Date: Thu, 19 Nov 2009 11:08:05 -0700
From: Alex Chiang <achiang@hp.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] ACPI: do not define acpi_processor_get_bios_limit() in
	processor.h (snd ver)
Message-ID: <20091119180805.GA4386@ldl.fc.hp.com>
References: <20091117220729.25933.57884.stgit@bob.kio> <20091117221125.25933.71150.stgit@bob.kio> <20091118000909.GB1855@redhat.com> <200911191231.02905.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911191231.02905.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Renninger <trenn@suse.de>:
> > 
> > There's 2-3 other fixes pending for the bios_limit patch.
> Alex removed the function that should have get
> static inline and that looks like the right fix for two
> mentioned problems.
> 
> > For now, I've dropped it from cpufreq.next, until Thomas sends
> > a rediffed version with the compilation problems fixed.
> Attached is my old version, merged with Alex's one.
> Alex drops out as author of the fix by that, hope that's ok
> with you.

That's fine, maybe do what akpm does...

[achiang@hp.com fix build breakage]
> CC: Pallipadi Venkatesh <venkatesh.pallipadi@intel.com>
> CC: Len Brown <lenb@kernel.org>
> CC: davej@codemonkey.org.uk
> CC: linux@dominikbrodowski.net
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

But either way is fine by me.

/ac
