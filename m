Return-Path: <linux-kernel-owner+w=401wt.eu-S933704AbZJGAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbZJGAH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933424AbZJGAH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:07:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1922 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbZJGAH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:07:56 -0400
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
In-Reply-To: <10f740e80910010155jdf5c898x80a3a848182148a1@mail.gmail.com>
References: <cover.1254193019.git.joe@perches.com>
	 <f28939e0018c7e2a9e898722e0fb8514a843b14c.1254193019.git.joe@perches.com>
	 <10f740e80910010010o4522a008h265e09d7988d7192@mail.gmail.com>
	 <1254382000.1799.13.camel@Joe-Laptop.home>
	 <10f740e80910010155jdf5c898x80a3a848182148a1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Oct 2009 17:07:17 -0700
Message-Id: <1254874037.2134.311.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 10:55 +0200, Geert Uytterhoeven wrote:
> On Thu, Oct 1, 2009 at 09:26, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2009-10-01 at 09:10 +0200, Geert Uytterhoeven wrote:
> >> > Standardize the printed style of UUID/GUIDs by using
> >> > another extension to %p.
> >> > %pU:    01020304-0506-0708-090a-0b0c0d0e0f10
> >> > %pUr:   04030201-0605-0807-090a-0b0c0d0e0f10
> >> > %pU[r]X:Use upper case hex
> >> To me, it looks a bit strange to have the options after the `U', combined with
> >> the variable-length nature.
> > I think the whole %p<foo> mechanism is strange and takes
> > a bit of getting used to.
> > You're free to suggest alternatives.
> `r' is reverse endianness?
> So what about
>     %pUb: lower case big endian
>     %pUl: lower case little endian
>     %pUB: upper case big endian
>     %pUL: upper case little endian
> That way it's fixed length, and easier to parse.

Thanks Geert.

That's OK with me.
%pU now defaults to %pUb and I'll resubmit it later.

Anyone else?

