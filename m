Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbYGRR0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbYGRR0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYGRRZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:25:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50682 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbYGRRZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:25:52 -0400
Subject: Re: [Jfs-discussion] latest -git: BUG at fs/jfs/namei.c:512
	assert(ip->i_nlink)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jfs-discussion@lists.sourceforge.net,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807181017i2fac8291n439c23843c55afd6@mail.gmail.com>
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <1216401356.11215.15.camel@norville.austin.ibm.com>
	 <19f34abd0807181017i2fac8291n439c23843c55afd6@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:25:47 -0500
Message-Id: <1216401947.11215.17.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 19:17 +0200, Vegard Nossum wrote:
> On Fri, Jul 18, 2008 at 7:15 PM, Dave Kleikamp
> <shaggy@linux.vnet.ibm.com> wrote:

> > Here's another patch
> >
> > JFS: validate di_fileset when reading inode from disk.
> 
> Thanks. On top of the previous one, I presume?

Yes.  I'm still looking at the others.

-- 
David Kleikamp
IBM Linux Technology Center

