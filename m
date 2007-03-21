Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXCUCMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXCUCMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXCUCMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:12:10 -0400
Received: from ozlabs.org ([203.10.76.45]:56243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXCUCMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:12:09 -0400
Date: Tue, 20 Mar 2007 21:12:02 -0500
From: Anton Blanchard <anton@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070321021202.GA11745@kryten>
References: <20070308.134825.45514445.davem@davemloft.net> <20070309024324.GA24695@kryten> <45F0E014.8060907@zytor.com> <20070308.202718.68040662.davem@davemloft.net> <45F0E309.70403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0E309.70403@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> The advantage would be that it wouldn't require a v3 for platforms for 
> which MIN_PAGE_SIZE == PAGE_SIZE, which accounts for a very large 
> percentage of systems.
> 
> You still have to look for the darn magic in two places, so there is no 
> reason for it to be different.

The problem is if you can hit in two places then what PAGE_SIZE should
you use to size the contents of the swap header while remaining backward
compatible.

Im leaning towards Dave suggestion of creating a clean v3 swap header.

Anton
