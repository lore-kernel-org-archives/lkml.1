Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZBCXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZBCXaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZBCX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:29:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:36178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZBCX3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:29:55 -0500
From: Thomas Renninger <trenn@suse.de>
To: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: CPUFREQ: Ondemand and powernow-k8 enhancements/fixes/cleanups
Date: Wed, 4 Feb 2009 00:29:51 +0100
User-Agent: KMail/1.9.10
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
References: <1233679606-1971-1-git-send-email-trenn@suse.de> <20090203212106.GK10486@codemonkey.org.uk>
In-Reply-To: <20090203212106.GK10486@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040029.51958.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 10:21:06 pm Dave Jones wrote:
> On Tue, Feb 03, 2009 at 05:46:39PM +0100, Thomas Renninger wrote:
>  > These are the same I sent out some days ago, but messed up the
>  > cpufreq list address.
>  >
>  > The patches are based against Dave's cpufreq git tree's fixes branch.
>
> 'fixes' is for stuff pending for .29, which this patchset seems out
> of scope for.  Unfortunatly, there's a ton of checkpatch cleanups up
> the 'next' branch which makes this impossible to apply.
Mark's latency fix for powernow-k8 should go to .29.
It's a sever fix which makes powernow-k8 work fine with ondemand
without tweaking sampling rate. Otherwise you could hit sever
performance loss, e.g. there are machines out there which currently
only check for frequency changes every 1.2 seconds (see comment #24):
https://bugzilla.novell.com/show_bug.cgi?id=436717

According to Mark, Windows PowerNow! driver also uses these ACPI
values and it got tested on various different K8 CPUs.
It should be the first patch touching powernow-k8, so this
one can be picked out of the rest.

> Can you rediff against that branch please?
The rest is not critical, I will rediff everything. I expect you still
want to have the whole series rebased, even if you decide to add
above one to .29?

Thanks,

     Thomas
