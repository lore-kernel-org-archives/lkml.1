Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZJLO7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZJLO7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZJLO7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:59:03 -0400
Received: from kroah.org ([198.145.64.141]:39843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZJLO7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:59:02 -0400
Date: Mon, 12 Oct 2009 07:55:46 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, stable@kernel.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [stable] patch
 kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch added to
 2.6.31-stable tree
Message-ID: <20091012145546.GB1517@kroah.com>
References: <20091009223815.20569488DB@coco.kroah.org>
 <200910101540.06686.s.L-H@gmx.de>
 <20091012094151.GA32228@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012094151.GA32228@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:41:51AM +0200, Joerg Roedel wrote:
> All the nested stuff was moved into its own sub-struct in 2.6.32. Here
> is a version that works with 2.6.31.3:
> 
> >From 4505a73070f341674e0d22a8c9ee51b2beeb843e Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 12 Oct 2009 11:19:07 +0200
> Subject: [PATCH 1/2] KVM: SVM: Fix tsc offset adjustment when running nested
> 
> When svm_vcpu_load is called while the vcpu is running in
> guest mode the tsc adjustment made there is lost on the next
> emulated #vmexit. This causes the tsc running backwards in
> the guest. This patch fixes the issue by also adjusting the
> tsc_offset in the emulated hsave area so that it will not
> get lost.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Thanks, but Marcelo just said we should drop the original patch.

Marcelo, if you want this one in instead, please let me know.

thanks,

greg k-h
