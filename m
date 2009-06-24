Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbZFXUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbZFXUa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZFXUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:30:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbZFXUaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:30:21 -0400
Message-ID: <4A428C9C.6080702@redhat.com>
Date: Wed, 24 Jun 2009 16:29:16 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Cihula, Joseph" <joseph.cihula@intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution Technology
 support for Linux - Details
References: <4A4024B6.2060600@intel.com> <20090623101110.60c0974d@lxorguk.ukuu.org.uk> <4F65016F6CB04E49BFFA15D4F7B798D9A2A3C1AE@orsmsx506.amr.corp.intel.com>
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9A2A3C1AE@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 05:04 PM, Cihula, Joseph wrote:
>> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] Sent: Tuesday,
>> June 23, 2009 2:11 AM
>> 
>> Is there a summary of what has changes from RFC v4 ?
> 
> -  The monolithic patch was broken into four patches that represent
> discrete functionality (boot and build, reboot/halt shutdown, Sx
> shutdown, forcing DMAR on).  An appropriate (and more descriptive)
> patch description was added to each patch.
> 
> -  Small stylistic cleanups (capitalization, comment wording,
> whitespace, etc.).
> 
> -  The code in hwsleep.c that populated the tboot ACPI structures was
> moved into its own function in tboot.c.
> 
> -  Use pr_warning(), pr_info(), pr_debug().
> 
> -  Moved some #include's from the middle of tboot.c to the top.
> 
> -  Changed the memory type of the tboot shared page from
> E820_UNUSABLE to E820_RESERVED (really a change to tboot, but
> requires a change here in the checking code).
> 
> And the new patches that I'm about to send have notes in the top
> indicating their changes from the previous versions.

So it still requires a giant binary blob to be loaded into main
memory to be executed by the main CPU with full privileges (or
plausibly even more lattitude than kernel normally has), right?

-- 
        Peter
