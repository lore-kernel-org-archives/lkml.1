Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYHGFxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYHGFxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYHGFxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:53:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52668
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbYHGFxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:53:37 -0400
Date: Wed, 06 Aug 2008 22:53:37 -0700 (PDT)
Message-Id: <20080806.225337.73678483.davem@davemloft.net>
To: bunk@kernel.org
Cc: a.beregalov@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc64: build failure at sys_sparc32.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804140532.GI6088@cs181140183.pp.htv.fi>
References: <a4423d670807290138p4a666337id74fe1fa637932e4@mail.gmail.com>
	<20080803.181934.262275514.davem@davemloft.net>
	<20080804140532.GI6088@cs181140183.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 4 Aug 2008 17:05:32 +0300

> The only platforms that do their own stuff instead of using the 
> functions from kernel/uid16.c are sparc64 and s390.
> 
> Is there any reason why sparc64 has it's own functions?

Thanks for pointing it out, I'll take advantage of those helper
routines.
