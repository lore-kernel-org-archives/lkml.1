Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXCTTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXCTTLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbXCTTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:11:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48604 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934035AbXCTTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:11:47 -0400
X-Originating-Ip: 74.108.131.3
Date: Tue, 20 Mar 2007 14:47:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
In-Reply-To: <20070320181442.1ae73295@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0703201447200.12350@localhost.localdomain>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
 <p73y7lu5yt6.fsf@bingen.suse.de> <20070320165736.GA19781@redhat.com>
 <20070320181442.1ae73295@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Alan Cox wrote:

> On Tue, 20 Mar 2007 12:57:36 -0400
> Dave Jones <davej@redhat.com> wrote:
>
> > On Sun, Mar 18, 2007 at 04:57:57PM +0100, Andi Kleen wrote:
> >  > "Robert P. J. Day" <rpjday@mindspring.com> writes:
> >  >
> >  > > Delete the allegedly obsolete raw driver feature, which has been
> >  > > marked for death since 2005.
> >  >
> >  > I think it would be better to replace it with a wrapper
> >  > that forces O_DIRECT and opens the underlying block device.  I suspect
> >  > just dropping it will break many people's database setups, which is not
> >  > nice.  Widely used admin interfaces should be only broken when
> >  > there is a very good reason and just "there is a better way now"
> >  > doesn't seem quite strong enough.
> >
> > Agreed.  Given how this keeps coming up every few months, lets just
> > remove that from the list..  It's not that a 306 line driver is
> > particularly invasive anyways..
> >
> > Signed-off-by: Dave Jones <davej@redhat.com>
>
> Acked-by: Alan Cox <alan@redhat.com>
>
> This is a user visible API it is therefore not elligable for removal
> anyway

great, now i can stop whining about it.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
