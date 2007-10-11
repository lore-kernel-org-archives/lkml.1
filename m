Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbXJKJpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbXJKJpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXJKJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:45:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60254
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXJKJpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:45:41 -0400
Date: Thu, 11 Oct 2007 02:45:29 -0700 (PDT)
Message-Id: <20071011.024529.112295019.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com, shemminger@linux-foundation.org
Subject: Re: + git-net-fix-qeth_main.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710110909.l9B99fEM021646@imap1.linux-foundation.org>
References: <200710110909.l9B99fEM021646@imap1.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Thu, 11 Oct 2007 02:03:27 -0700

> Subject: git-net: fix qeth_main.c
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/s390/net/qeth_main.c: In function 'qeth_hard_header_parse':
> drivers/s390/net/qeth_main.c:6584: error: 'dev' undeclared (first use in this function)
> drivers/s390/net/qeth_main.c:6584: error: (Each undeclared identifier is reported only once
> drivers/s390/net/qeth_main.c:6584: error: for each function it appears in.)
> 
> "David S. Miller" <davem@davemloft.net>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Sorry :(  This is like the 7th or 8th build failure introduced
by Stephen's headerops patch.

Applied, thanks Andrew.
