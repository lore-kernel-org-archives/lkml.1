Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbXJOIjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbXJOIjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbXJOIjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:39:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54528
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbXJOIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:39:19 -0400
Date: Mon, 15 Oct 2007 01:39:24 -0700 (PDT)
Message-Id: <20071015.013924.48816492.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: jesper.juhl@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@redhat.com, kuznet@ms2.inr.ac.ru
Subject: Re: Don't leak 'listeners' in netlink_kernel_create()
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1hckt5nyp.fsf@ebiederm.dsl.xmission.com>
References: <200710142337.01059.jesper.juhl@gmail.com>
	<m1hckt5nyp.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 14 Oct 2007 16:30:06 -0600

> Jesper Juhl <jesper.juhl@gmail.com> writes:
> 
> > From: Jesper Juhl <jesper.juhl@gmail.com>
> > Subject: Don't leak 'listeners' in netlink_kernel_create()
> >
> > The Coverity checker spotted that we'll leak the storage allocated 
> > to 'listeners' in netlink_kernel_create() when the
> >   if (!nl_table[unit].registered)
> > check is false.
> >
> > This patch avoids the leak.
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> 
> This patch appears trivially correct to me.
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied, thanks everyone.
