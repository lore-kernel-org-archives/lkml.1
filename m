Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYIIBUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYIIBUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYIIBTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:19:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23515 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYIIBTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:19:53 -0400
Date: Mon, 8 Sep 2008 18:14:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, garyhade@us.ibm.com,
       linux-mm@kvack.org, y-goto@jp.fujitsu.com, mel@csn.ul.ie,
       lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Cleanup to make  remove_memory() arch neutral
Message-Id: <20080908181454.4aec7d49.randy.dunlap@oracle.com>
In-Reply-To: <20080908175621.6dfad0a6.akpm@linux-foundation.org>
References: <20080905172132.GA11692@us.ibm.com>
	<20080905174449.GC27395@elte.hu>
	<1220638478.25932.20.camel@badari-desktop>
	<20080905181754.GA14258@elte.hu>
	<1220910754.25932.57.camel@badari-desktop>
	<20080908175621.6dfad0a6.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 17:56:21 -0700 Andrew Morton wrote:

> On Mon, 08 Sep 2008 14:52:34 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > There is nothing architecture specific about remove_memory().
> > remove_memory() function is common for all architectures which
> > support hotplug memory remove. Instead of duplicating it in every
> > architecture, collapse them into arch neutral function.
> > 
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > 
> >  arch/ia64/mm/init.c   |   17 -----------------
> >  arch/powerpc/mm/mem.c |   17 -----------------
> >  arch/s390/mm/init.c   |   11 -----------
> >  mm/memory_hotplug.c   |   10 ++++++++++
> >  4 files changed, 10 insertions(+), 45 deletions(-)
> 
> I spent some time trying to build-test this on ia64 and gave up.  How
> the heck do you turn on memory hotplug on ia64?

After using ia64 defconfig, all I had to do was enable Sparse Memory model
instead of Discontiguous.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
