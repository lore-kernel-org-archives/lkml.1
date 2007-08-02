Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXHBUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXHBUmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXHBUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:42:19 -0400
Received: from deine-taler.de ([217.160.107.63]:50475 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbXHBUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:42:17 -0400
Date: Thu, 2 Aug 2007 22:42:16 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-ID: <20070802204216.GA10311@deine-taler.de>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com> <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de> <20070802230219.97b7f7b5.vsu@altlinux.ru> <46B22C25.2070601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B22C25.2070601@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> Yup... it should probably be pointed out the reason the old kernel 
> worked was nothing but pure dumb luck.  This was a GNU ld change which 
> needed to be undone for klibc.  It's unfortunate that stock x86-64 
> binaries leave as little of a null pointer range as they do, but that's 
> life, unfortunately.  The other alternative is to map klibc just below 
> the 2 GB point, which would also work, but the old way broke when the ld 
> change went in.  As previously stated, klibc-1.4.35 or higher fixes this.
> 
> 	-hpa

Just for the record: The kernel with the PIE patch boots perfectly
using the klibc 1.5 shared binaries on my machine.

-- 
Uli Kunitz
