Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXC3FDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXC3FDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXC3FDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:03:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39470 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXC3FDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:03:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Chuck Ebbert" <cebbert@redhat.com>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB2B@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Thu, 29 Mar 2007 15:05:56 -0700")
References: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB2B@fmsmsx411.amr.corp.intel.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Thu, 29 Mar 2007 23:03:00 -0600
Message-ID: <m18xdfjpbv.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Williams, Mitch A" <mitch.a.williams@intel.com> writes:

> Chuck Ebbert wrote:
>>Are you going to post one for 2.6.20 as well? Some people might be
>>interested...
>
> The first time I posted this patch, Greg KH indicated that he thought
> it was too intrusive to add to -stable, especially considering that
> our MSI-X capable hardware isn't in the field yet.

There is MSI-X capable hardware supported by the kernel in 2.6.20.

The last version of your patch with the code removed from the set_affinity
path is not very intrusive at all, as it just touches msi.c

Eric
