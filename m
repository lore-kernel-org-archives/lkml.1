Return-Path: <linux-kernel-owner+w=401wt.eu-S936587AbXFFXDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936587AbXFFXDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935709AbXFFXDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:03:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40366
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935566AbXFFXDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:03:20 -0400
Date: Wed, 06 Jun 2007 16:02:10 -0700 (PDT)
Message-Id: <20070606.160210.23014574.davem@davemloft.net>
To: drepper@redhat.com
Cc: davidel@xmailserver.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
       dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
From: David Miller <davem@davemloft.net>
In-Reply-To: <46673BE5.8040605@redhat.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606.154434.21926922.davem@davemloft.net>
	<46673BE5.8040605@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Wed, 06 Jun 2007 15:57:41 -0700

> I would strongly argue that any change we're doing in this area at
> userlevel would involve a new interface.  Programs also need new
> definitions from headers files.  This means a recent enough glibc will
> be needed in any case.  Unless programs use their own definitions in
> which case they might as well use the syscall() function.

To be honest, after reading Alan's response a few moments ago
I'm growing in favor of his suggestions and that all of these
new system calls perhaps really are overkill.
