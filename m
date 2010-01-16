Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0APJEd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151Ab0APJEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:04:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48134
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0APJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:04:26 -0500
Date: Sat, 16 Jan 2010 01:04:35 -0800 (PST)
Message-Id: <20100116.010435.55169828.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: bpidoux@free.fr, bernard.pidoux@upmc.fr, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        linux-hams@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH net-2.6] ax25: netrom: rose: Fix timer oopses
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100115203654.GA3084@del.dom.local>
References: <4B2E6729.1090102@free.fr>
	<4B507FAA.8010007@free.fr>
	<20100115203654.GA3084@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Fri, 15 Jan 2010 21:36:54 +0100

> Wrong ax25_cb refcounting in ax25_send_frame() and by its callers can
> cause timer oopses (first reported with 2.6.29.6 kernel).
> 
> Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14905
> 
> Reported-by: Bernard Pidoux <bpidoux@free.fr>
> Tested-by: Bernard Pidoux <bpidoux@free.fr>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Applied, thanks everyone.
