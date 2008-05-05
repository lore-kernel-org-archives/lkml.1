Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYEEILc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYEEILc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYEEILP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:11:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50623
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbYEEILO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:11:14 -0400
Date: Mon, 05 May 2008 01:11:14 -0700 (PDT)
Message-Id: <20080505.011114.218022391.davem@davemloft.net>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, davidel@xmailserver.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805050342.m453gktl029817@devserv.devel.redhat.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Sun, 4 May 2008 23:42:46 -0400

> This patch adds support for flag values which are ORed to the type passwd
> to socket and socketpair.  The additional code is minimal.  Beside
> decoding the flags with the library function introduced in a prior patch
> all that has to be done is to pass the new value around.
> 
> The internal functions sock_alloc_fd and sock_map_fd get a new parameters
> and all callers are changed.
...
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
