Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZFCP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZFCP1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZFCP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:27:15 -0400
Received: from kroah.org ([198.145.64.141]:39099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZFCP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:27:10 -0400
Date: Wed, 3 Jun 2009 07:59:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the x86
	tree
Message-ID: <20090603145901.GB30890@kroah.com>
References: <20090603171830.b2f80b02.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603171830.b2f80b02.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 05:18:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/x86/kernel/microcode_core.c between commit
> 871b72dd1e12afc3f024479531d25a9339d2e3f9 ("x86: microcode: use
> smp_call_function_single instead of set_cpus_allowed, cleanup of
> synchronization logic") from the x86 tree and commit
> 3b5f472624ad5b54753388bb3c563a8f308eed88 ("Driver Core: misc: add
> nodename support for misc devices") from the driver-core tree.
> 
> Just white space changes overlapping an addition.  I fixed it up (see
> below) and can carry the fix as necessary.

Thanks, I'll watch for this when merging with Linus.

greg k-h
