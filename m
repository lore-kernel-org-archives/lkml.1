Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXEETWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXEETWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXEETWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:22:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXEETWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:22:34 -0400
Date: Sat, 5 May 2007 12:22:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Adrian Bunk <bunk@stusta.de>, jsipek@cs.sunysb.edu,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org
Subject: Re: [-mm patch] fix unionfs compilation
Message-Id: <20070505122213.fa8fc210.akpm@linux-foundation.org>
In-Reply-To: <20070505191313.GA5834@filer.fsl.cs.sunysb.edu>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<20070505170012.GF8975@stusta.de>
	<20070505115718.a1a0b61e.akpm@linux-foundation.org>
	<20070505191313.GA5834@filer.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 15:13:13 -0400 Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:

> As it was discussed a while back on the mailing lists, Unionfs is trying to
> be smart and tries to do reallocation on its own. The way it does it makes
> it depend on some internals of the SLAB allocator. There have been some
> patches out there for a realloc function (by Pekka Enberg, IIRC), but as far
> as I can tell, they haven't been merged in.

krealloc should be in mainline within a couple of days.
