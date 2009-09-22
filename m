Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIVVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIVVS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZIVVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:18:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52089
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbZIVVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:18:56 -0400
Date: Tue, 22 Sep 2009 14:19:14 -0700 (PDT)
Message-Id: <20090922.141914.61481427.davem@davemloft.net>
To: cernekee@gmail.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] kaweth: Fix memory leak in kaweth_control()
From: David Miller <davem@davemloft.net>
In-Reply-To: <6a1f935a6229adafb68d0e1ca7bc71fa@localhost>
References: <6a1f935a6229adafb68d0e1ca7bc71fa@localhost>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Cernekee <cernekee@gmail.com>
Date: Fri, 18 Sep 2009 18:43:30 -0700

> kaweth_control() never frees the buffer that it allocates for the USB
> control message.  Test case:
> 
> while :; do ifconfig eth2 down ; ifconfig eth2 up ; done
> 
> This is a tiny buffer so it is a slow leak.  If you want to speed up the
> process, you can change the allocation size to e.g. 16384 bytes, and it
> will consume several megabytes within a few minutes.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Applied, thanks.

I've been trying to wait to give time for people like david-b
to review and bless the various USB networking patches that have
been posted over the past few weeks but I'm running out of
patience :-)

So simple ones like this I'm just gonna apply.
