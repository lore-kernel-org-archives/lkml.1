Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYJNBky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYJNBky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYJNBkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:40:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51099
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYJNBko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:40:44 -0400
Date: Mon, 13 Oct 2008 18:40:20 -0700 (PDT)
Message-Id: <20081013.184020.193699133.davem@davemloft.net>
To: cooldavid@cooldavid.org
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, jgarzik@redhat.com, ron.mercer@qlogic.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] 2.6.27-git2 - fix build error at csum_ipv6_magic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013192101.M74635@cooldavid.org>
References: <20081013121441.GB14372@linux.vnet.ibm.com>
	<20081013192101.M74635@cooldavid.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
Date: Tue, 14 Oct 2008 03:28:14 +0800

> But since <net/ip6_checksum.h> compensate the lack of
> `csum_ipv6_magic` function defined in <asm/checksum.h>
> of some architecture, should <net/ip6_checksum.h> be
> included in <net/checksum.h> as well?

No, the standard convention is that if you need to call this
ipv6 checksumming routine you include net/ip6_checksum.h
From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
Date: Tue, 14 Oct 2008 03:28:14 +0800

> BTW, if there is a patch against jme driver which I maintain,
> and I just simply agree with it, should I silently noticed that
> and let someone like Jeff or David to review/apply it,
> or should I reply an ack of it?

You can ACK it and I usually apply patches like this directly.
