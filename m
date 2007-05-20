Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbXETG2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbXETG2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbXETG2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:28:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52821 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbXETG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:28:23 -0400
Date: Sun, 20 May 2007 07:28:16 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Uwe Bugla <uwe.bugla@gmx.de>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Message-ID: <20070520062816.GA4095@ftp.linux.org.uk>
References: <464F42F3.1080300@madrabbit.org> <20070519191751.E51233A23A2@muan.mtu.ru> <200705200124.13026.uwe.bugla@gmx.de> <200705200845.43621.arvidjaar@mail.ru> <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> Ken? Ball's in your court. As the patch isn't providing a killer
> feature for 2.6.22, I'd suggest just reverting it for now until the
> issues are ironed out.

Hold it.  The real question here is which logics do we want there.
IOW, and how many device nodes do we want to appear and _when_ do
we want them to appear?
