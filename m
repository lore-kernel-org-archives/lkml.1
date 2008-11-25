Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbYKYISv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbYKYISv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKYISm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:18:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33366
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYKYISm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:18:42 -0500
Date: Tue, 25 Nov 2008 00:18:41 -0800 (PST)
Message-Id: <20081125.001841.57751578.davem@davemloft.net>
To: hch@lst.de
Cc: torvalds@osdl.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove __ARCH_WANT_COMPAT_SYS_PTRACE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081125071003.GA592@lst.de>
References: <20081125071003.GA592@lst.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 25 Nov 2008 08:10:03 +0100

> All architectures now use the generic compat_sys_ptrace, as should every
> new architecture that needs 32bit compat (if we'll ever get another).
> 
> Remove the now superflous __ARCH_WANT_COMPAT_SYS_PTRACE define, and also
> kill a comment about __ARCH_SYS_PTRACE that was added after
> __ARCH_SYS_PTRACE was already gone.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
