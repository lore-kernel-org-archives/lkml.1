Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZKRA4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZKRA4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZKRA4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:56:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZKRA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:56:10 -0500
Date: Tue, 17 Nov 2009 19:09:09 -0500
From: Dave Jones <davej@redhat.com>
To: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 2/3] ACPI: do not define acpi_processor_get_bios_limit()
 in processor.h
Message-ID: <20091118000909.GB1855@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alex Chiang <achiang@hp.com>, Len Brown <lenb@kernel.org>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	Thomas Renninger <trenn@suse.de>
References: <20091117220729.25933.57884.stgit@bob.kio>
 <20091117221125.25933.71150.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117221125.25933.71150.stgit@bob.kio>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:11:25PM -0700, Alex Chiang wrote:
 > If we provide a definition for acpi_processor_get_bios_limit(), we will
 > encounter build errors (multiple definitions of the function) when we
 > do not have CONFIG_CPU_FREQ configured.
 > 
 > We've already changed the modules that depend on this function to only
 > get built when CONFIG_CPU_FREQ is configured, so removing the definition
 > when unconfigured is safe.
 > 
 > Cc: Thomas Renninger <trenn@suse.de>
 > Cc: Len Brown <lenb@kernel.org>
 > Signed-off-by: Alex Chiang <achiang@hp.com>
 > ---
 > 
 >  include/acpi/processor.h |    5 -----
 >  1 files changed, 0 insertions(+), 5 deletions(-)

There's 2-3 other fixes pending for the bios_limit patch.
For now, I've dropped it from cpufreq.next, until Thomas sends
a rediffed version with the compilation problems fixed.

	Dave

