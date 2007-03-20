Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXCTRNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXCTRNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXCTRNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:13:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37829 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965537AbXCTRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:13:37 -0400
Date: Tue, 20 Mar 2007 18:14:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070320181442.1ae73295@lxorguk.ukuu.org.uk>
In-Reply-To: <20070320165736.GA19781@redhat.com>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 12:57:36 -0400
Dave Jones <davej@redhat.com> wrote:

> On Sun, Mar 18, 2007 at 04:57:57PM +0100, Andi Kleen wrote:
>  > "Robert P. J. Day" <rpjday@mindspring.com> writes:
>  > 
>  > > Delete the allegedly obsolete raw driver feature, which has been
>  > > marked for death since 2005.
>  > 
>  > I think it would be better to replace it with a wrapper
>  > that forces O_DIRECT and opens the underlying block device.  I suspect 
>  > just dropping it will break many people's database setups, which is not
>  > nice.  Widely used admin interfaces should be only broken when 
>  > there is a very good reason and just "there is a better way now" 
>  > doesn't seem quite strong enough.
> 
> Agreed.  Given how this keeps coming up every few months, lets just
> remove that from the list..  It's not that a 306 line driver is
> particularly invasive anyways..
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Alan Cox <alan@redhat.com>

This is a user visible API it is therefore not elligable for removal
anyway
