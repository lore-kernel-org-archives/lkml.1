Return-Path: <linux-kernel-owner+w=401wt.eu-S1750802AbXBVDLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750802AbXBVDLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXBVDLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:11:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbXBVDLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:11:54 -0500
Date: Wed, 21 Feb 2007 19:10:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 18/24] Xen-paravirt_ops: Some generic early printk &
 boot console fixups
Message-Id: <20070221191047.8d21acaa.akpm@linux-foundation.org>
In-Reply-To: <20070221205323.842917348@goop.org>
References: <20070221205254.169835700@goop.org>
	<20070221205323.842917348@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 12:53:12 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Some generic early printk & boot console fixups
> (already sent to lkml).

hm, this patch series seems to have gone out of its way to cause problems.

This particular (pathetically changelogged) patch is already in my tree,
only in a later, much more comprehensive form.  Similarly the HVC changes
were already in Rusty's stuff and were supposed to be merged by Paulus, but
haven't been yet.

Can we just drop this one?  Does the Xen work actually depend on it?

