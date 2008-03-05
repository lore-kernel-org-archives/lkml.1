Return-Path: <linux-kernel-owner+w=401wt.eu-S1764060AbYCEV4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764060AbYCEV4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763212AbYCEVzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:55:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762835AbYCEVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:55:34 -0500
Date: Wed, 5 Mar 2008 13:54:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.25-rc3-mm1 ppc64 boot hang
Message-Id: <20080305135425.c8ebf8e4.akpm@linux-foundation.org>
In-Reply-To: <1204752855.7939.42.camel@dyn9047017100.beaverton.ibm.com>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<1204752855.7939.42.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 13:34:14 -0800
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Tue, 2008-03-04 at 01:19 -0800, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> > 
> 
> Hi Andrew,
> 
> Not able to boot 2.6.25-rc3-mm1 my ppc64 box.
> 2.6.25-rc2-mm1 and 2.6.25-rc3 boots fine.
> 
> I applied slab.c fix also.
> 
> Any other known issues ? My config file attached.
> Here are the messages on the console.

The semaphore consolidation code enables interrupts early in boot, when it
shouldn't.  This tends to make powerpc blow up.  Could be that this is what
you're hitting.

Matthew, is this ging to be fixed soon?

Thanks.  
