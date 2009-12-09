Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZLIH1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZLIH1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbZLIH1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:27:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbZLIH1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:27:10 -0500
Date: Wed, 9 Dec 2009 08:26:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH] arch/x86/kernel/microcode*: Use pr_fmt and remove
 duplicated KERN_ERR prefix
Message-ID: <20091209072630.GA8187@elte.hu>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
 <1260313613.27677.169.camel@Joe-Laptop.home>
 <20091209060538.GD2512@elte.hu>
 <1260340250.27677.191.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260340250.27677.191.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2009-12-09 at 07:05 +0100, Ingo Molnar wrote:
> > > > -		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
> > > > +		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
> > > Duplicates KERN_ERR
> > Indeed - please send a delta fix as this has been merged already.
> 
> Use #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove "microcode: " prefix from each pr_<level>
> Fix duplicated KERN_ERR prefix
> Coalesce pr_<level> format strings
> Add a space after an exclamation point
> No other change in output
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/microcode_amd.c   |   40 +++++++++++++++----------------
>  arch/x86/kernel/microcode_core.c  |   26 +++++++++++---------
>  arch/x86/kernel/microcode_intel.c |   47 +++++++++++++++---------------------
>  3 files changed, 53 insertions(+), 60 deletions(-)

very nice. I've applied it, thanks Joe!

	Ingo
