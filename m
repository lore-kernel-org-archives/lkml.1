Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXKAWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXKAWmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXKAWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:42:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52143
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbXKAWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:42:36 -0400
Date: Thu, 01 Nov 2007 15:42:35 -0700 (PDT)
Message-Id: <20071101.154235.158959733.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, davem@redhat.com
Subject: Re: [IRDA] IRNET: Fix build when TCGETS2 is defined.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071101223253.6804abb8@the-village.bc.nu>
References: <200711011959.lA1JxPWc003735@hera.kernel.org>
	<20071101223253.6804abb8@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 1 Nov 2007 22:32:53 +0000

[ davem@redhat.com is not my upstream email address, please don't
  use it for public discussions, thank you ]

> I'll go split the n_tty_ioctl stuff up and sort this cleanly for the
> serial ppp and other users as well.  Will send a patch tomorrow that
> makes ldisc catching of TCGET/SET calls unneccessary.

Thanks.

Please also do something with the x86/termios.h patch I sent you as
well, it will prevent these kind of boo-boos in the future.
