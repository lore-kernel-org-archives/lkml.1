Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbYCFVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbYCFVji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761017AbYCFVj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:39:27 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52678 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbYCFVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:39:26 -0500
Subject: Re: [PATCH 1/5] generic __remove_pages() support
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1204836859.4772.32.camel@nimitz.home.sr71.net>
References: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
	 <1204829734.7939.61.camel@dyn9047017100.beaverton.ibm.com>
	 <1204836859.4772.32.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 13:42:43 -0800
Message-Id: <1204839763.6272.8.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 12:54 -0800, Dave Hansen wrote:
> On Thu, 2008-03-06 at 10:55 -0800, Badari Pulavarty wrote:
> > +               if (memmap)
> > +                       __kfree_section_memmap(memmap, PAGES_PER_SECTION);
> > +               return;
> > +       }
> > +
> > +       /*
> > +        * Allocations came from bootmem - how do I free up ?
> > +        */
> > +
> 
> Shouldn't we figure this one out before merging?
> 
> I think we at least need a printk() there.

I can add a printk(). I am hoping Yasunori Goto has something to
handle this, before we really merge into mainline.

Thanks,
Badari

