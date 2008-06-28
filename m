Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYF1Ijc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYF1Ijc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 04:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYF1IjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 04:39:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYF1IjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 04:39:05 -0400
Date: Sat, 28 Jun 2008 01:39:05 -0700 (PDT)
Message-Id: <20080628.013905.146863178.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080627062556.GA1521@havoc.gtf.org>
References: <20080627062556.GA1521@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 27 Jun 2008 02:25:56 -0400

> Please pull from 'davem-next' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-next

Please fix these new build failures and warnings then send me another
pull request :-)

drivers/net/wan/retina.c: In function 'fepci_stream_open':
drivers/net/wan/retina.c:930: warning: cast from pointer to integer of different size
drivers/net/wan/retina.c:930: warning: cast to pointer from integer of different size
drivers/net/wan/retina.c:933: warning: cast from pointer to integer of different size
drivers/net/wan/retina.c:933: warning: cast to pointer from integer of different size
drivers/net/wan/retina.c: In function 'fepci_stream_interrupt':
drivers/net/wan/retina.c:1129: error: 'struct fepci_ch_private' has no member named 'cur'
make[3]: *** [drivers/net/wan/retina.o] Error 1
make[2]: *** [drivers/net/wan] Error 2
make[2]: *** Waiting for unfinished jobs....

Thanks!
