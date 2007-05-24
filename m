Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbXEXTAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbXEXTAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXEXTAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:00:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27009 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXEXTAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:00:42 -0400
Date: Thu, 24 May 2007 11:57:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Jan Kara" <jack@suse.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ben Fennema" <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Message-Id: <20070524115735.a1a2e32e.randy.dunlap@oracle.com>
In-Reply-To: <84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
References: <20070523184436.GA14771@cvg>
	<84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 21:47:42 +0300 Pekka Enberg wrote:

> Hi Cyrill,
> 
> On 5/23/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > @@ -2103,7 +1944,7 @@ long udf_block_map(struct inode *inode, sector_t block)
> >  	kernel_lb_addr eloc;
> >  	uint32_t elen;
> >  	sector_t offset;
> > -	struct extent_position epos = { NULL, 0, { 0, 0}};
> > +	struct extent_position epos = {};
> 
> Bits like these in the middle of indentation fixes makes me feel
> uneasy. Could we simply ask Andrew to run Lindent on the UDF sources
> at some convinient point and push those to Linus like we did with
> mm/slab.c if I recall correctly? Its safer to do cleanups like these
> after that.

but Lindent needs some hand-holding / eyeball help as well...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
