Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXBVIdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXBVIdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXBVIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:33:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:60234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXBVIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:33:15 -0500
Message-ID: <45DD553E.4000301@suse.de>
Date: Thu, 22 Feb 2007 09:33:02 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 18/24] Xen-paravirt_ops: Some generic early printk & boot
 console fixups
References: <20070221205254.169835700@goop.org>	<20070221205323.842917348@goop.org> <20070221191047.8d21acaa.akpm@linux-foundation.org> <45DD2E9E.5030601@goop.org>
In-Reply-To: <45DD2E9E.5030601@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
>> hm, this patch series seems to have gone out of its way to cause problems.
>>
>> This particular (pathetically changelogged) patch is already in my tree,
>> only in a later, much more comprehensive form.  Similarly the HVC changes
>> were already in Rusty's stuff and were supposed to be merged by Paulus, but
>> haven't been yet.
>>
>> Can we just drop this one?  Does the Xen work actually depend on it?

Yes.  The other which made it into -mm via lkml is a more recent version
of the same patch (+documentation, +!x86 arch updates).

On the hvm_console.c changes: there is just a small change needed to
make it build on !ppc, that should be identical identical in my (xen)
and rusty (lguest) patch series.  Patching it only once is fine for
obvious reasons ;)

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
