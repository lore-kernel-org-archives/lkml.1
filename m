Return-Path: <linux-kernel-owner+w=401wt.eu-S2992890AbXCICoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992890AbXCICoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992897AbXCICoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:44:13 -0500
Received: from ozlabs.org ([203.10.76.45]:44016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992890AbXCICoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:44:12 -0500
Date: Thu, 8 Mar 2007 20:43:25 -0600
From: Anton Blanchard <anton@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070309024324.GA24695@kryten>
References: <20070308175729.GA7054@kryten> <45F05040.4090602@zytor.com> <20070308214236.GA4154@kryten> <20070308.134825.45514445.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308.134825.45514445.davem@davemloft.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> I might be missing something but doesn't this break every
> SWAP partition that was created with something other than
> MIN_PAGE_SIZE?

It does. I was thinking we could work around it in ppc64 (64kB is quite
new), but I forgot there are options on sparc64 to change the page size :)

The other option is to create a v3 swap format that doesnt use any
PAGE_SIZE parameters.

Anton
