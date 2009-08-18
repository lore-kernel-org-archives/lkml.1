Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZHRB1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZHRB1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZHRB1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:27:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56627
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZHRB1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:27:43 -0400
Date: Mon, 17 Aug 2009 18:27:54 -0700 (PDT)
Message-Id: <20090817.182754.50348941.davem@davemloft.net>
To: tim.bird@am.sony.com
Cc: r.schwebel@pengutronix.de, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       arjan@linux.intel.com, kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: new ipdelay= option for faster netboot
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A8A02CA.7040305@am.sony.com>
References: <4A89DB15.6060101@am.sony.com>
	<20090817.180323.253692704.davem@davemloft.net>
	<4A8A02CA.7040305@am.sony.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tim.bird@am.sony.com>
Date: Mon, 17 Aug 2009 18:24:26 -0700

> David Miller wrote:
>> I have card/switch combinations that take up to 10 seconds to
>> negotiate a proper link.
> 
> What types of delays are these timeouts supposed to
> cover?

The problem is that if you don't first give at least some time for the
link to come up, the remaining time it takes the link to come up will
end up chewing into the actual bootp/dhcp protocol timeouts.  And
that's what we're trying to avoid.
