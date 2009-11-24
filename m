Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbZKXUaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbZKXUaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbZKXUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:30:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932960AbZKXUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:30:04 -0500
Date: Tue, 24 Nov 2009 12:29:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups
Message-Id: <20091124122937.ac9371d0.akpm@linux-foundation.org>
In-Reply-To: <20091122111901.5e99a391@dxy.sh.intel.com>
References: <20091122111901.5e99a391@dxy.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 11:19:01 +0800
Alek Du <alek.du@intel.com> wrote:

> >From 9ba8224f5246ef7fdf1c0a15bb5535e442731435 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Sun, 22 Nov 2009 10:58:21 +0800
> Subject: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups
> 
> 1. Use >= N to check invalid gpio number (unsigned type)

I already had this in gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

> 2. Remove wrong and unnecessary unmask operation
> 3. Remove extra GEDR reading
> 
> The 2) and 3) will fix interrupts losing when two or more pins are triggered at close time.
> 

Those aren't cleanups - they're bug fixes!

How important are they?
