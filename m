Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZBKVqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZBKVqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZBKVpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:45:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48588
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbZBKVpu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:45:50 -0500
Date: Wed, 11 Feb 2009 13:45:44 -0800 (PST)
Message-Id: <20090211.134544.171113049.davem@davemloft.net>
To: clement.lecigne@netasq.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt
From: David Miller <davem@davemloft.net>
In-Reply-To: <op.uo6zs6xiw20ydt@clem1.netasq.com>
References: <op.uo6zs6xiw20ydt@clem1.netasq.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clément LECIGNE <clement.lecigne@netasq.com>
Date: Wed, 11 Feb 2009 15:56:56 +0100

> Hello lkml,
> 
> In function sock_getsockopt() located in net/core/sock.c, optval v.val is not correctly initialized and directly returned in userland in case we have SO_BSDCOMPAT option set.
> 
> This dummy code should trigger the bug:

Some problems with your patch:

1) Your patch doesn't apply properly.  It has been corrupted.

   Somehow, even though you used an attachment, tab characters were
   transformed into spaces.

2) Networking patches should be sent with at least
   netdev@vger.kernel.org CC:'d so that your patch gets
   properly traced at http://patchwork.ozlabs.org/project/netdev/list/

3) You need to provide a proper "Signed-off-by:" line with your
   patch description.  See linux/Documentation/SubmittingPatches
   for details.

Please fix these issues up and resubmit your patch.

Thank you.

