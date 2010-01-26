Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976Ab0AZKIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab0AZKIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149Ab0AZKIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:08:42 -0500
Received: from smtp.nokia.com ([192.100.122.230]:51747 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0AZKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:08:41 -0500
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Matt Mackall <mpm@selenic.com>
Cc: Jeff Angielski <jeff@theptrgroup.com>, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <1264500214.3867.21.camel@localhost>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
	 <1264484928.3536.1017.camel@calx>  <1264500214.3867.21.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 12:07:41 +0200
Message-ID: <1264500461.3867.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Jan 2010 10:07:56.0040 (UTC) FILETIME=[6E2BC080:01CA9E6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 12:03 +0200, Artem Bityutskiy wrote:
> On Mon, 2010-01-25 at 23:48 -0600, Matt Mackall wrote:
> > Hmm. I'd just as soon drop it entirely. Here's a patch. Herbert, you
> > want to send this through your crypto tree?
> > 
> > 
> > random: drop weird m_time/a_time manipulation
> > 
> > No other driver does anything remotely like this that I know of except
> > for the tty drivers, and I can't see any reason for random/urandom to do
> > it. In fact, it's a (trivial, harmless) timing information leak. And
> > obviously, it generates power- and flash-cycle wasting I/O, especially
> > if combined with something like hwrngd. Also, it breaks ubifs's
> > expectations.
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>

Just in case anyone wonders where this came from, here is the beginning
of the thread:

http://lists.infradead.org/pipermail/linux-mtd/2010-January/028727.html

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

