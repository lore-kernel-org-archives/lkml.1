Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYKMUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYKMUam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYKMUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:30:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYKMUad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:30:33 -0500
Subject: Re: [PATCH 25 of 38] xen mtrr: Add mtrr_ops support for Xen mtrr
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
In-Reply-To: <61b4b844fb80206fbda1.1226603423@abulafia.goop.org>
References: <61b4b844fb80206fbda1.1226603423@abulafia.goop.org>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 20:28:48 +0000
Message-Id: <1226608128.19068.10.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 11:10 -0800, Jeremy Fitzhardinge wrote:

> diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
> new file mode 100644
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/mtrr/xen.c
> @@ -0,0 +1,59 @@
...
> +
> +/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
> + * working userland mtrr support. */
> +static struct mtrr_ops xen_mtrr_ops = {
> +	.vendor            = X86_VENDOR_UNKNOWN,
> +//	.set               = xen_set_mtrr,
> +//	.get               = xen_get_mtrr,
> +	.get_free_region   = generic_get_free_region,
> +//	.validate_add_page = xen_validate_add_page,
> +	.have_wrcomb       = positive_have_wrcomb,
> +	.use_intel_if	   = 0,
> +	.num_var_ranges	   = xen_num_var_ranges,
> +};

...

I'm vague on the details now, but looking back at the dom0 patch set
here:

http://git.et.redhat.com/?p=linux-2.6-dom0-pvops.git;a=shortlog;h=55abc194080b5cf31cd66f5e35e8e5c5af2aa927

I see we did have a bunch more mtrr work e.g. fixing the TODO above:

http://git.et.redhat.com/?p=linux-2.6-dom0-pvops.git;a=commitdiff;h=93f779bf3d79f28d0933bfbc53f7b8c5b6496081

Cheers,
Mark.

