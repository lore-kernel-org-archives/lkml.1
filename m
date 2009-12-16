Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZLPKtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZLPKtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZLPKtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:49:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:48057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbZLPKtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:49:08 -0500
Subject: Re: [folded]
 kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch removed from
 -mm tree
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com, joe@perches.com,
       mingo@elte.hu, nooiwa@miraclelinux.com, mm-commits@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <25197.1260917095@localhost>
References: <200912150108.nBF18TNx015047@imap1.linux-foundation.org>
	 <1260872882.4165.353.camel@twins>  <25197.1260917095@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:48:24 +0100
Message-ID: <1260960504.17860.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 17:44 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 15 Dec 2009 11:28:02 +0100, Peter Zijlstra said:
> > On Mon, 2009-12-14 at 17:08 -0800, akpm@linux-foundation.org wrote:
> > > s/_rl/_ratelimited/g
> > 
> > do we feel this pr_* wankery is worth the hassle? I'd as soon send a
> > patch removing all this crap.
> 
> pr_foo() instead of printk(KERN_FOO) is probably worth the hassle, as it
> allows more selective inclusion of messages if you're trying to build an
> embedded kernel.  It's easy to say "I want pr_warning() to stay in, but
> lower levels compile to nothing". Trying to keep a 'printk(KERN_WARNING'
> while making a printk(KERN_DEBUG go away is just asking for some truly
> astounding pre-processor gyrations.

So we are depricating printk()?

Last time I asked that the answer was no, at which point there is
absolutely no point in using pr_* wankery.

And I much prefer the printk() thing, because
 1) my fingers know it
 2) it looks like the userspace printf thing
 3) its an easier pattern to grep for



