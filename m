Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXISXL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXISXL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXISXLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:11:49 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42541 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXISXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:11:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 19 Sep 2007 16:11:45 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Miller <davem@davemloft.net>
cc: tomer_iisc@yahoo.com, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <20070919.154402.34760338.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0709191552171.2989@alien.or.mcafeemobile.com>
References: <130356.85796.qm@web53703.mail.re2.yahoo.com>
 <20070919.154402.34760338.davem@davemloft.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, David Miller wrote:

> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
> 
> > With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> > not return, even when the incoming acks free the buffers.
> >         Note that this patch assumes that the SOCK_NOSPACE check in
> > tcp_check_space is a trivial optimization which can be safely removed.
> 
> I already replied to your patch posting explaining that whatever is
> not setting SOCK_NOSPACE should be fixed instead.
> 
> Please address that, thanks.

You're not planning of putting the notion of a SOCK_NOSPACE bit inside a 
completely device-unaware interface like epoll, I hope?



- Davide


