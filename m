Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYADKTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYADKTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYADKTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:19:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35526
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYADKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:19:47 -0500
Date: Fri, 04 Jan 2008 02:19:46 -0800 (PST)
Message-Id: <20080104.021946.100193287.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: matthias@goebl.net, linux-kernel@vger.kernel.org, kkeil@suse.de,
       kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn/i4l: 'NO CARRIER' message lost after ldisc flush
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080103223054.2b51450b@lxorguk.ukuu.org.uk>
References: <1178571957.3665.8.camel@amdx2.microgate.com>
	<20080103220039.GV19071@night.goebl.net>
	<20080103223054.2b51450b@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 3 Jan 2008 22:30:54 +0000

> > For non-audio connections the problem remains.
> > Maybe we can remove the tty_ldisc_flush() in isdn_tty_modem_result()
> > at all because it's done at tty_close?
> 
> I'm not sure I understand why the tty_ldisc_flush is being done in the
> ISDN layer at this point but this change looks fine to me.

I'll apply this fix to net-2.6 and push to Linus.

Thanks.
