Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXLaMVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXLaMVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbXLaMU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:20:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36744
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758280AbXLaMU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:20:56 -0500
Date: Mon, 31 Dec 2007 04:20:55 -0800 (PST)
Message-Id: <20071231.042055.145660385.davem@davemloft.net>
To: 7eggert@gmx.de
Cc: jengelh@computergmbh.de, devzero@web.de, linux-kernel@vger.kernel.org,
       bunk@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bodo Eggert <7eggert@gmx.de>
Date: Mon, 31 Dec 2007 13:09:43 +0100 (CET)

> As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> on normal systems. This is especially true since udev needs these sockets
> and fails to run if UNIX=m.
> 
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

People who use udev can make sure they have it built into their kernel
if they have such a dependency.

Not everyone uses udev, and therefore needs AF_UNIX non-modular.

I keep seeing this crap patch get submitted and I'm going to keep
dropping it because it's bogus.

It seems to stem from some filesystem interface or whatever that the
VFS folks don't want to export or one they want to now stop exporting.

But that is a really cruddy reason to want to force AF_UNIX to not
be allowed to be modular, and the udev thing just makes it more of a
joke rather than a good technical reason.
