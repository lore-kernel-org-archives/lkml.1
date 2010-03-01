Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab0CAOkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:40:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:60495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0CAOkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:40:25 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH -v11] x86: fix out of order of gsi -- partial
Date: Mon, 1 Mar 2010 15:40:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       hpa@zytor.com, garyhade@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com
References: <4B882182.4030205@kernel.org> <20100228080941.GD14205@elte.hu> <4B8A31DD.4000408@kernel.org>
In-Reply-To: <4B8A31DD.4000408@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003011540.17866.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 February 2010 10:05:33 Yinghai Lu wrote:
> On 02/28/2010 12:09 AM, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >>
> >> found IBM x3950 will have problem after
> >>
> >> |commit b9c61b70075c87a8612624736faf4a2de5b1ed30
> > 
> > Have you seen the commit notifications i sent for the v8 patches:
> > 
> > Commit-ID:  ca8c764cb39bf6cade71933b38e8c830eb8b73c6
> > Commit-ID:  519d637a93116ffbcd50e9e3f2591f41584f372c
> > 
> > Those include a much improved changelogs - please adopt those. (and preferably 
> > send deltas against tip:tmp.x86/apic.)
> 
> please drop those two.
>  
> will send v12 to you.
Eh, not sure, but could it be Ingo forgot the 2nd
part of v12?

In linux-2.6-tip I see:
commit fad539956c9e69749a03f7817d22d1bab87657bf
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Feb 28 01:06:34 2010 -0800

    x86: Fix out of order of gsi

which equals:
[PATCH -v12 1/2] x86: fix out of order of gsi -- partial

but I cannot see:
[PATCH -v12 2/2] x86: fix out of order of gsi - full

Also this machine booted/worked fine up to 2.6.30.
Any chance this will get addressed in stable@ kernel(s)?

Thanks,

   Thomas
