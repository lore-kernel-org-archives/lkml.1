Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbZJGI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbZJGI23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbZJGI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:28:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36057
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321AbZJGI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:28:26 -0400
Date: Wed, 07 Oct 2009 01:28:21 -0700 (PDT)
Message-Id: <20091007.012821.184426837.davem@davemloft.net>
To: tilman@imap.cc
Cc: alan@lxorguk.ukuu.org.uk, alan@linux.intel.com, paulus@samba.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, jarkao2@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ppp: fix comments - ppp_{sync,asynctty}_receive()
 may sleep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091001142844.C50E511186D@xenon.ts.pxnet.com>
References: <20091001142844.C50E511186D@xenon.ts.pxnet.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Thu,  1 Oct 2009 16:28:44 +0200 (CEST)

> The receive_buf methods of the N_PPP and N_SYNC_PPP line disciplines,
> ppp_asynctty_receive() and ppp_sync_receive(), call tty_unthrottle()
> which may sleep. Fix the comments claiming otherwise.
> 
> Impact: documentation
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied, thanks.
