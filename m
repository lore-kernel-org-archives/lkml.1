Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXGaHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXGaHj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXGaHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:39:18 -0400
Received: from ozlabs.org ([203.10.76.45]:37329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXGaHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:39:17 -0400
Subject: Re: [PATCH] CPU online file permission
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20070730165720.37780cc6.akpm@linux-foundation.org>
References: <200707300056.l6U0ukUe021931@devserv.devel.redhat.com>
	 <20070730165720.37780cc6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 17:38:55 +1000
Message-Id: <1185867535.6131.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 16:57 -0700, Andrew Morton wrote:
> On Sun, 29 Jul 2007 20:56:46 -0400
> Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > Is there a reason why the "online" file in the subdirectories for the CPUs
> > in /sys/devices/system isn't world-readable?
> 
> No sane one which I can think of.  It seems that it originally sprang forth
> from Rusty's keyboard in that form.

Hmm, that seems possible but unlikely.  My original version used proc,
after all.

But either way, fix is good.

Rusty.

