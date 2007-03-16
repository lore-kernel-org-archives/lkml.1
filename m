Return-Path: <linux-kernel-owner+w=401wt.eu-S965924AbXCPU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965924AbXCPU6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965925AbXCPU6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:58:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41941
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965924AbXCPU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:58:23 -0400
Date: Fri, 16 Mar 2007 13:58:21 -0700 (PDT)
Message-Id: <20070316.135821.125896069.davem@davemloft.net>
To: clameter@sgi.com
Cc: mbligh@mbligh.org, andi@firstfloor.org, rostedt@goodmis.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       chrisw@sous-sol.org, rusty@rustcorp.com.au, glommer@gmail.com,
       apw@shadowen.org
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703161354520.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
	<20070316.135316.115910811.davem@davemloft.net>
	<Pine.LNX.4.64.0703161354520.6204@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 16 Mar 2007 13:56:13 -0700 (PDT)

> On Fri, 16 Mar 2007, David Miller wrote:
> 
> > From: Christoph Lameter <clameter@sgi.com>
> > Date: Fri, 16 Mar 2007 13:48:58 -0700 (PDT)
> > 
> > > Please read my posts to linux-mm on that subject. We discussed it last 
> > > year in detail and the agreement was that the sparsemem crud needs to be 
> > > taken out. Kame-san posted patches to do that.
> > 
> > Please don't do that, sparsemem works very well on sparc64 and I
> > like the flexibility it gives me.
> 
> I am not sure what flexibility you are talking about? The modification are 
> to make sparsemem support virtual memmap as one option. See Kame-san's 
> posts. There is no regression here its just cutting out the overhead of 
> sparsmem from within.

I would really appreciate a posting that explains what exactly is
going on being sent to linux-arch, this is the first time I myself am
even aware of this idea and work.

Thanks.
