Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXGBXYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXGBXYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXGBXYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:24:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbXGBXYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:24:13 -0400
Date: Mon, 2 Jul 2007 19:22:55 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
Message-ID: <20070702232255.GH6403@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20070701202037.GC10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701202037.GC10869@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 10:20:37PM +0200, Adrian Bunk wrote:

Hi Adrian,

 > This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
 > 
 > Signed-off-by: Adrian Bunk <bunk@stusta.de>
 > Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 > Acked-by: Dave Jones <davej@redhat.com>

Can you do this against -mm please ?
There's been some changes, which mean that your patch won't apply
without fuzz, which git-apply hates.

(19:06:04:davej@hera:cpufreq)$ git-applymbox -k ~/cf
1 patch(es) to process.

Applying '[CPUFREQ] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI'

error: patch failed: arch/x86_64/kernel/cpufreq/Kconfig:65
error: arch/x86_64/kernel/cpufreq/Kconfig: patch does not apply


Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
