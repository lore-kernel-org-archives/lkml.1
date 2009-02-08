Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZBHSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZBHSgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZBHSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:35:58 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:15269 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZBHSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=vDvscY2nWDmDZRK4InHLvshupD1eVngDbtWWTO3JA9dcltRsWWcwGJbrg49948W0LY
         RQ8RA3azIJw1COUhjHwn3Tx+Dr+DUeHBAJ6UjK+e6AWLghd5s0B0wZvVlxvTAS1T5Vr2
         4WPsOcOweKYA2h+Gk5yxfO6zHaS+JsfPVC8H8=
Message-ID: <498F2608.9030809@gmail.com>
Date: Sun, 08 Feb 2009 12:35:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Thomas Renninger <trenn@suse.de>
CC: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] CPUFREQ: powernow-k8: Get transition latency from
 ACPI _PSS table
References: <1233679606-1971-1-git-send-email-trenn@suse.de> <1233679606-1971-5-git-send-email-trenn@suse.de>
In-Reply-To: <1233679606-1971-5-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> At this time, the PowerNow! driver for K8 uses an experimentally
> derived formula to calculate transition latency.  The value it
> provides is orders of magnitude too large on modern systems.
> This patch replaces the formula with ACPI _PSS latency values
> for more accuracy and better performance.
> 
> I've tested it on two 2nd generation Opteron systems, a 3rd
> generation Operton system, and a Turion X2 without seeing any
> stability problems.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   28 ++++++++++++++++++++++------
>  1 files changed, 22 insertions(+), 6 deletions(-)

Hopefully somebody is pushing this for .29? This seems to make a big 
difference in system responsiveness on my Athlon X2 system.
