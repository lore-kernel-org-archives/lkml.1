Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXJUKUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXJUKUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXJUKUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:20:08 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:58880 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbXJUKUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:20:06 -0400
Date: Sun, 21 Oct 2007 12:17:02 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Coly Li <coyli@suse.de>
Cc: Jiri Kosina <jikos@jikos.cz>, Dave Haywood <tla@oak.selfip.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: PROBLEM: oops, Linus tree: 2.6.23-g4fa4d23f, BUG: unable to
 handle kernel NULL pointer dereference at virtual address 00000004
Message-ID: <20071021121702.4816ca1f@inria.fr>
In-Reply-To: <471AE0B0.4060600@suse.de>
References: <4719B727.7090908@oak.selfip.net>
	<Pine.LNX.4.64.0710201246540.18815@twin.jikos.cz>
	<3d8471ca0710200432h3607b0a0i9169884ebec3b940@mail.gmail.com>
	<471AE0B0.4060600@suse.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sun, 21 Oct 2007 13:16:32 +0800,
Coly Li <coyli@suse.de> a écrit :

> > This should be fixed in recent git by
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9b013e05e0289c190a53d78ca029e2f21c0e4485
> > 
> Maybe we encounter same condition, at least the symbol name is same -- sock_setsockopt.

> [ 4327.550291] EFLAGS: 00010282   (2.6.23-bigsmp-g4fa4d23f #6)

You are testing a kernel that does not contain the aforementioned fix,
so you should update your git checkout (using a kernel that can connect
to the Internet ;-) ) and test the new kernel.

Thanks.

-- 
Guillaume
