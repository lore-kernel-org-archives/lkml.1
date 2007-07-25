Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXGYUGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXGYUGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXGYUF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:05:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbXGYUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:05:56 -0400
Date: Wed, 25 Jul 2007 13:05:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.23-rc1-mm1
Message-Id: <20070725130502.b0e4c8df.akpm@linux-foundation.org>
In-Reply-To: <46A744D1.3070300@fr.ibm.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46A744D1.3070300@fr.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 14:40:49 +0200
Cedric Le Goater <clg@fr.ibm.com> wrote:

> Hello,
> 
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> 
> found that one on ppc,
> 
> drivers/char/hw_random/pasemi-rng.c:140: error: unknown field 'type' specified in initializer
> drivers/char/hw_random/pasemi-rng.c:140: warning: initialization makes pointer from integer without a cast
> 
> hwrng-add-type-categories.patch modifies a struct of the wrong type.
> 
> the pasemi-rng driver registers a 'of_platform_driver' not a 'hwrng'.
> 

OK, thanks.  Those patches generated a decent-sized flamewar anyway so I
think I'll drop them as obviosuly some more thought/discussion is needed
there.

