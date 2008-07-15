Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYGOVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYGOVr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYGOVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:47:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37906
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbYGOVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:47:20 -0400
Date: Tue, 15 Jul 2008 14:47:20 -0700 (PDT)
Message-Id: <20080715.144720.66126410.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: jeff@garzik.org, torvalds@linux-foundation.org, tytso@mit.edu,
       david@lang.hm, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216157061.26991.41.camel@shinybook.infradead.org>
References: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
	<487D1327.7090805@garzik.org>
	<1216157061.26991.41.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 15 Jul 2008 14:24:21 -0700

> Kernel 2.6.15 with ancient userland. You update to 2.6.16, which
> includes commit 5433383e ('convert qla2xxx to request_firmware()').
> 
> Same problem?

For the record I did get burnt by that one and I did make a huge stink
about it.

I used to be able to avoid initrd entirely on every single one of my
boxes, even my machines with qla2xxx based root filesystems, and that
changeset basically meant the end of that.

I simply don't do much hacking on that particular machine any more,
it's not worth the pain just to get a kernel that boots on it.

Yes, I know I can do stupid things like use the dist's initrd image
and just ignore the module version warnings, which is what Linus
happens to do, but that's just too gross for my tastes.
