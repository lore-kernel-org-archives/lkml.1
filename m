Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYK0IVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYK0IVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYK0IVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:21:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38437
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbYK0IVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:21:04 -0500
Date: Thu, 27 Nov 2008 00:21:03 -0800 (PST)
Message-Id: <20081127.002103.78160620.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       netdev@vger.kernel.org, cl@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount
 special vfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <492DDCAB.1070204@cosmosbay.com>
References: <4926D39D.9050603@cosmosbay.com>
	<20081121153453.GA23713@elte.hu>
	<492DDCAB.1070204@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 27 Nov 2008 00:32:59 +0100

> This function arms a flag (MNT_SPECIAL) on the vfs, to avoid
> refcounting on permanent system vfs.
> Use this function for sockets, pipes, anonymous fds.
> 
> (socket8 bench result : from 2.94s to 2.23s)
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
