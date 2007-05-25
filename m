Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXEYWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXEYWxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXEYWxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:53:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:38137 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbXEYWxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:53:39 -0400
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.575306000@sonycom.com> <200705251826.25572.arnd@arndb.de>
	 <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:53:08 +1000
Message-Id: <1180133588.19517.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 21:40 +0200, Geert Uytterhoeven wrote:
> 
> I used a kthread because the request function of a block device driver
> must be
> non-blocking, and ps3stor_read_write_sectors() calls
> wait_for_completion().

Which as I said before looks terribly sad... Why the heck would it have
to do that ?

Ben.


