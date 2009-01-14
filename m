Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZANWKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZANWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZANWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:10:46 -0500
Received: from cs-studio.ru ([195.178.208.66]:33794 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbZANWKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:10:46 -0500
Date: Thu, 15 Jan 2009 01:10:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [take2] OOM documentation update [was: Linux killed Kenny, bastard!]
Message-ID: <20090114221043.GA6039@ioremap.net>
References: <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com> <20090114161225.GA9584@ioremap.net> <20090114170606.GB12102@ioremap.net> <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:53:16PM -0500, Bryan Donlan (bdonlan@gmail.com) wrote:
> On Wed, Jan 14, 2009 at 12:06 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> 
> > + * resulted score is multiplied by the two in the power of oom_adj when it is
> > +       positive, and divided otherwise, i.e.
> > +       points <<= oom_adj when it is positive and
> > +       points >>= oom_adj otherwise
> 
> Two to the power of a negative number is equivalent to dividing by two
> to the power of said exponent's absolute value, making this paragraph
> more than a bit confusing - indeed, a literal read would make it
> equivalent to multiplying by 2^abs(oom_adj).
> 
> I would think that the following would be enough:
> * The resulting score is multiplied by two to the power of oom_adj.

Yes, I think it is enough with shift example.

Thanks guys I will update the doc.

-- 
	Evgeniy Polyakov
