Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbXBVFsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbXBVFsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXBVFsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:48:14 -0500
Received: from gw.goop.org ([64.81.55.164]:36703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbXBVFsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:48:12 -0500
Message-ID: <45DD2E9E.5030601@goop.org>
Date: Wed, 21 Feb 2007 21:48:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 18/24] Xen-paravirt_ops: Some generic early printk & boot
 console fixups
References: <20070221205254.169835700@goop.org>	<20070221205323.842917348@goop.org> <20070221191047.8d21acaa.akpm@linux-foundation.org>
In-Reply-To: <20070221191047.8d21acaa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> hm, this patch series seems to have gone out of its way to cause problems.
>
> This particular (pathetically changelogged) patch is already in my tree,
> only in a later, much more comprehensive form.  Similarly the HVC changes
> were already in Rusty's stuff and were supposed to be merged by Paulus, but
> haven't been yet.
>
> Can we just drop this one?  Does the Xen work actually depend on it?

Well, some form of the hvc patches is needed to get a console.  I'll
rationalize them with respect to Gerd and Rusty's latest patches, but I
did want to make the series stand on its own rather than have external
dependencies on unmerged patches.

    J
