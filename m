Return-Path: <linux-kernel-owner+w=401wt.eu-S1764884AbYCEWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764884AbYCEWcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCEWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:32:26 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36714 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbYCEWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:32:25 -0500
Subject: Re: 2.6.25-rc3-mm1 ppc64 boot hang
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Matthew Wilcox <willy@debian.org>
In-Reply-To: <20080305135425.c8ebf8e4.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <1204752855.7939.42.camel@dyn9047017100.beaverton.ibm.com>
	 <20080305135425.c8ebf8e4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 14:35:42 -0800
Message-Id: <1204756542.7939.44.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 13:54 -0800, Andrew Morton wrote:
> On Wed, 05 Mar 2008 13:34:14 -0800
> Badari Pulavarty <pbadari@gmail.com> wrote:
> 
> > On Tue, 2008-03-04 at 01:19 -0800, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> > > 
> > 
> > Hi Andrew,
> > 
> > Not able to boot 2.6.25-rc3-mm1 my ppc64 box.
> > 2.6.25-rc2-mm1 and 2.6.25-rc3 boots fine.
> > 
> > I applied slab.c fix also.
> > 
> > Any other known issues ? My config file attached.
> > Here are the messages on the console.
> 
> The semaphore consolidation code enables interrupts early in boot, when it
> shouldn't.  This tends to make powerpc blow up.  Could be that this is what
> you're hitting.
> 
> Matthew, is this ging to be fixed soon?

Yes. I just backed out git-semaphore.patch and machine booted fine.

Thanks,
Badari

