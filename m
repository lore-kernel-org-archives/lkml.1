Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXEXW2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXEXW2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXEXW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:28:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbXEXW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:28:07 -0400
Message-ID: <46561145.6000304@zytor.com>
Date: Thu, 24 May 2007 15:27:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org>
In-Reply-To: <20070524150223.41063046.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> @@ -23,13 +23,14 @@ static int show_cpuinfo(struct seq_file 
>                 "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
>                 "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
>                 "pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
> -               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
> +               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", NULL,
> 
> <wonders where pbe went to>
> 

I just went through all the codepaths, and we filter this bit in all the
appropriate places, so it's safe to display.  I've added it to both i386
and x86-64 in the git.newsetup tree (the two were inconsistent.)

	-hpa
