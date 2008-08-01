Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYHAGNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYHAGNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 02:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYHAGNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 02:13:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYHAGNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 02:13:08 -0400
Date: Thu, 31 Jul 2008 23:12:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on
 powerpc
Message-Id: <20080731231206.80940fba.akpm@linux-foundation.org>
In-Reply-To: <20080801052936.GZ20457@bakeyournoodle.com>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
	<4891B370.5040208@linux.vnet.ibm.com>
	<20080801052936.GZ20457@bakeyournoodle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 15:29:36 +1000 Tony Breeds <tony@bakeyournoodle.com> wrote:

> On Thu, Jul 31, 2008 at 06:13:28PM +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> > 
> > make allyesconfig with 2.6.27-rc1-mm1 kernel on powerpc fails with build error
> 
> <snip>
> 
> Turning off GCOV "fixes" this.  Not really the best solution but at
> least it narrows doen the search effort.

Thanks.

> Peter,
> 	Can you have a look at how this can be fixed, if at all?
> 

Am not terribly happy with the state of the gcov patches.  They STILL
leave thousands of dead symlinks lying around after `make mrproper' and
generally seem to muck up the kbuild system a bit, although nothing
that a bit of Sam love wouldn't fix.

Plus it breaks the build on a few architectures (branch out of range,
mainly), but that's a fairly minor thing which could even be worked
around in Kconfig (disable the offending code if gcov is enabled)


