Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbZJND2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbZJND2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZJND2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:28:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:56126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZJND2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:28:39 -0400
Subject: Re: [PATCH] 8250_pci: Add IBM Saturn serial card
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Reed <mreed10@us.ibm.com>,
       stable@kernel.org
In-Reply-To: <20091013194121.49d2d9ae.akpm@linux-foundation.org>
References: <1255477253.2347.22.camel@pasglop>
	 <20091013194121.49d2d9ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 14:26:30 +1100
Message-Id: <1255490790.2347.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 19:41 -0700, Andrew Morton wrote:
> On Wed, 14 Oct 2009 10:40:53 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > The IBM Saturn serial card has only one port. Without that fixup,
> > the kernel thinks it has two, which confuses userland setup and
> > admin tools as well.
> > 
> 
> That sounds seriousish.  I assume it's a long-standing problem, but we
> only just noticed it?

No it's a brand new piece of HW we haven't released yet :-)

> I'll cc -stable because it's so simple ;)

Heh, thanks. We need it into distro indeed.

> > Andrew & Others on CC... not sure who takes care of patches to
> > that driver nowadays. Should I send directly to Linus ?
> 
> I'll grab them if I see them, especially simple ones.  Sometimes Alan
> grabs them too.

Thanks.

Cheers,
Ben.


