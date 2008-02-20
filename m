Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbYBTVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbYBTVUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYBTVU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:20:27 -0500
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:49110 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYBTVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:20:26 -0500
X-ME-UUID: 20080220212022976.025F47000084@mwinf3109.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, chris2553@googlemail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802202150.20303.IvDoorn@gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <1203523555.693.2.camel@localhost.localdomain>
	 <1203539235.3189.4.camel@boulder.homenet>
	 <200802202150.20303.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 21:16:35 +0000
Message-Id: <1203542195.3240.1.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 21:50 +0100, Ivo van Doorn wrote:
[snip]
> On Wednesday 20 February 2008, Chris Vine wrote:
> > I did that yesterday and it just reported a kernel panic on the terminal
> > with the message:
> > 
> >   Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> I have an idea, could you try below patch?
> Note that while applying it will mention something about a line offset, but that can be ignored.
> 
> This could perhaps also fix the TX/RX issue mentioned earlier in the thread, but I am not
> quite sure about that.

The patch applied OK (with some offsets as you say) but it doesn't help.
The kernel panic still occurs when association is attempted.

Chris


