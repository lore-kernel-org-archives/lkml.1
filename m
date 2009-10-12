Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZJLRBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZJLRBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZJLRBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:01:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2080 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbZJLRBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:01:06 -0400
Subject: Re: [PATCH 05/21] amd_iommu.c: use pr_<level> and add pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org
In-Reply-To: <20091012150036.GH32228@amd.com>
References: <cover.1254701151.git.joe@perches.com>
	 <2a3001d41382d567f2693f72b7fda331c2fe1d52.1254701151.git.joe@perches.com>
	 <20091012150036.GH32228@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 10:00:28 -0700
Message-Id: <1255366828.1839.55.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 17:00 +0200, Joerg Roedel wrote:
> On Sun, Oct 04, 2009 at 05:53:32PM -0700, Joe Perches wrote:
> > Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > Converted a few bare printks to pr_cont 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   71 ++++++++++++++++++++++--------------------
> >  1 files changed, 37 insertions(+), 34 deletions(-)
> Applied to amd-iommu/cleanups. Thanks Joe.

Hi Jeorg:

Looking back at the original patch:

> 	default:
> -		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
> +		pr_cont("\n");
> +		pr_err("UNKNOWN type=0x%02x]\n", type);

The default case probably had an incorrect KERN_ERR and should be

	pr_cont("UNKNOWN type=0x%02x]\n", type);

cheers, Joe

