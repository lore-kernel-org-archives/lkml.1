Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXDFXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXDFXSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXDFXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:18:34 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbXDFXSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:18:32 -0400
Date: Fri, 6 Apr 2007 16:18:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 09/20] rename struct paravirt_patch to
 paravirt_patch_site for clarity
Message-Id: <20070406161822.a9f828a4.akpm@linux-foundation.org>
In-Reply-To: <20070404191205.617690202@goop.org>
References: <20070404191151.009821039@goop.org>
	<20070404191205.617690202@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 12:12:00 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rename struct paravirt_patch to paravirt_patch_site, so that it
> clearly refers to a callsite, and not the patch which may be applied
> to that callsite.

Needed a bit of updating for Andi's recently-merged
x86_64-mm-vmi-backend-for-paravirt-ops.patch but I think I got it
right.  We'll see if it compiles.

