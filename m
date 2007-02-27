Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219AbXB0Rft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbXB0Rft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXB0Rft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:35:49 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:58794 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbXB0Rfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:35:47 -0500
Subject: Re: [patch 09/26] Xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME,
	define no-op architecture implementations
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-arch@vger.kernel.org
In-Reply-To: <45E46889.9090801@goop.org>
References: <20070227081337.434798469@goop.org>
	 <20070227081632.356636957@goop.org>
	 <1172589358.3408.2.camel@mulgrave.il.steeleye.com>
	 <45E46889.9090801@goop.org>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 11:35:26 -0600
Message-Id: <1172597726.3408.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 09:21 -0800, Jeremy Fitzhardinge wrote:
> You mean add the two stubs to asm-generic/mmu_context.h, and then
> include that in all these files?  That would be cleaner, but it
> wouldn't
> remove the need to touch all these files, would it?

it would if you added asm-generic/mmu_context_paravirt.h

and only included that in the main kernel files that need the three
operations (that's just fork.c and mmap.c, isn't it)?

James


