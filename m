Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZJAH0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZJAH0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZJAH0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:26:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1576 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbZJAH0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:26:38 -0400
Subject: Re: [PATCH 1/9] lib/vsprintf.c: Add %pU to print UUID/GUIDs
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Alex Elder <aelder@sgi.com>, Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <10f740e80910010010o4522a008h265e09d7988d7192@mail.gmail.com>
References: <cover.1254193019.git.joe@perches.com>
	 <f28939e0018c7e2a9e898722e0fb8514a843b14c.1254193019.git.joe@perches.com>
	 <10f740e80910010010o4522a008h265e09d7988d7192@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 00:26:40 -0700
Message-Id: <1254382000.1799.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 09:10 +0200, Geert Uytterhoeven wrote:
> > Standardize the printed style of UUID/GUIDs by using
> > another extension to %p.
> >
> > %pU:    01020304-0506-0708-090a-0b0c0d0e0f10
> > %pUr:   04030201-0605-0807-090a-0b0c0d0e0f10
> > %pU[r]X:Use upper case hex
> 
> To me, it looks a bit strange to have the options after the `U', combined with
> the variable-length nature.

I think the whole %p<foo> mechanism is strange and takes
a bit of getting used to.

You're free to suggest alternatives.

Keep in mind expansion for future different types and that
<foo> must be alphanumeric chars only.

cheers, Joe

