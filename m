Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYEEIQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYEEIQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYEEIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:16:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58075
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbYEEIQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:16:12 -0400
Date: Mon, 05 May 2008 01:16:12 -0700 (PDT)
Message-Id: <20080505.011612.192490132.davem@davemloft.net>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, davidel@xmailserver.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 13/18] flag parameters: NONBLOCK in socket and
 socketpair
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805050342.m453gkn4029850@devserv.devel.redhat.com>
References: <200805050342.m453gkn4029850@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Sun, 4 May 2008 23:42:46 -0400

> This patch introduces support for the SOCK_NONBLOCK flag in socket,
> socketpair, and  paccept.  To do this the internal function sock_attach_fd
> gets an additional parameter which it uses to set the appropriate flag for
> the file descriptor.
> 
> Given that in modern, scalable programs almost all socket connections are
> non-blocking and the minimal additional cost for the new functionality
> I see no reason not to add this code.
 ...
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
