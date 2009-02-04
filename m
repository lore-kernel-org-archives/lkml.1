Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZBDFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZBDFE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZBDFEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:04:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbZBDFET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:04:19 -0500
Date: Tue, 3 Feb 2009 21:03:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Renninger <trenn@suse.de>
Cc: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] CPUFREQ: ondemand/conservative: deprecate
 sampling_rate{min,max}
Message-Id: <20090203210334.a99354ee.akpm@linux-foundation.org>
In-Reply-To: <1233679606-1971-3-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
	<1233679606-1971-3-git-send-email-trenn@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Feb 2009 17:46:41 +0100 Thomas Renninger <trenn@suse.de> wrote:

>  static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
>  {
> +	printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
> +	       "sysfs file is deprecated - used by: %s\n", current->comm);
>  	return sprintf (buf, "%u\n", MAX_SAMPLING_RATE);
>  }

I'd have thought that the user-irritation risk here is pretty high.

Would it make sense to throttle these or to make them once-per-boot
or something?

