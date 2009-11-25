Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbZKYBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbZKYBGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZKYBGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:06:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:20101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933753AbZKYBGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,282,1257148800"; 
   d="scan'208";a="470333168"
Date: Wed, 25 Nov 2009 09:02:05 +0800
From: Alek Du <alek.du@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups
Message-ID: <20091125090205.122e59a3@dxy.sh.intel.com>
In-Reply-To: <20091124122937.ac9371d0.akpm@linux-foundation.org>
References: <20091122111901.5e99a391@dxy.sh.intel.com>
	<20091124122937.ac9371d0.akpm@linux-foundation.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 04:29:37 +0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 22 Nov 2009 11:19:01 +0800
> Alek Du <alek.du@intel.com> wrote:
> 
> > >From 9ba8224f5246ef7fdf1c0a15bb5535e442731435 Mon Sep 17 00:00:00 2001
> > From: Alek Du <alek.du@intel.com>
> > Date: Sun, 22 Nov 2009 10:58:21 +0800
> > Subject: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups
> > 
> > 1. Use >= N to check invalid gpio number (unsigned type)
> 
> I already had this in gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
> 
> > 2. Remove wrong and unnecessary unmask operation
> > 3. Remove extra GEDR reading
> > 
> > The 2) and 3) will fix interrupts losing when two or more pins are triggered at close time.
> > 
> 
> Those aren't cleanups - they're bug fixes!
I agree, thx.

> 
> How important are they?

It is not show stopper one, but would be great if could commit to 2.6.32 rcx.

Thanks,
Alek
