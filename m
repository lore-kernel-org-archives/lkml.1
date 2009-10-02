Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZJBQ5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZJBQ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZJBQ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:57:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41959
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbZJBQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:57:05 -0400
Date: Fri, 02 Oct 2009 09:57:24 -0700 (PDT)
Message-Id: <20091002.095724.12562070.davem@davemloft.net>
To: philipp.reisner@linbit.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, dm-devel@redhat.com, zbr@ioremap.net,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910021754.12940.philipp.reisner@linbit.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
	<20091002135859.GA9383@kroah.com>
	<200910021754.12940.philipp.reisner@linbit.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Fri, 2 Oct 2009 17:54:12 +0200

> Think of the connector as a layer on top of netlink that allows more
> than a hard coded number of subsystems to use netlink.

There are no such limits in netlink, we have 'genetlink' which allows
an arbitrary number of subsystems to use netlink.

What connector provides over netlink/genetlink is something different
altogether.
