Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXDDRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXDDRmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXDDRmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:42:47 -0400
Received: from thunk.org ([69.25.196.29]:49996 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXDDRmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:42:46 -0400
Date: Wed, 4 Apr 2007 13:41:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org, paulus@samba.org,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404174153.GI31973@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404122154.GF31973@thunk.org> <4613CF6A.2090407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4613CF6A.2090407@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 09:16:42AM -0700, H. Peter Anvin wrote:
> One option would be to move the 8250-based serial ports, to, say, 
> /dev/ttyN* (for National Semiconductors -- the best I could come up 
> with) and redefine /dev/ttyS* as a serial port multiplexer which maps in 
> all the types, for the ones that really want dynamic mapping.

> Of course, now you have the potential of aliasing, again, which tends to 
> cause all kinds of headaches w.r.t. locking.  

That would break the 99.9% of the the world using Intel-based systems
which only have 8250's, for very little gain. 

Like it or not, /dev/ttySx and 8250 UART's are to serial ports what
the PCI is to system buses....

						- Ted
