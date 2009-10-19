Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZJSNOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZJSNOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZJSNOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:14:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36176
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755572AbZJSNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:14:37 -0400
Date: Mon, 19 Oct 2009 06:14:59 -0700 (PDT)
Message-Id: <20091019.061459.193694892.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: tomoki.sekiyama.qu@hitachi.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       satoshi.oshima.fk@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       hideo.aoki.tk@hitachi.com
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091019115713.GB6869@ff.dom.local>
References: <4ADC010C.5070809@hitachi.com>
	<20091019115713.GB6869@ff.dom.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 19 Oct 2009 11:57:13 +0000

> Isn't the shutdown call expected to change sk_state to TCP_CLOSE?

No, because the send side is still up and operational, it's
only a half duplex close.
