Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZHCU3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZHCU3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZHCU3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:29:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbZHCU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:29:16 -0400
Date: Mon, 03 Aug 2009 13:29:24 -0700 (PDT)
Message-Id: <20090803.132924.151782729.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, oliver@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090803142616.GA1973@darkstar>
References: <20090803142616.GA1973@darkstar>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 3 Aug 2009 22:26:16 +0800

> rfcomm tty may be used before rfcomm_tty_driver initilized,
> The problem is that now socket layer init before tty layer, if userspace
> program do socket callback right here then oops will happen.
> 
> reporting in:
> http://marc.info/?l=linux-bluetooth&m=124404919324542&w=2
 ...
> Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
> Tested-by: Oliver Hartkopp <oliver@hartkopp.net>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Applied, thanks.
