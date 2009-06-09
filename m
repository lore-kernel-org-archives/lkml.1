Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbZFII7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbZFII7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZFII7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:59:02 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33805 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZFII7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:59:01 -0400
Message-ID: <4A2E2456.4020703@msgid.tls.msk.ru>
Date: Tue, 09 Jun 2009 12:59:02 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jonathan@jonmasters.org, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, romieu@fr.zoreil.com, stable@kernel.org
Subject: Re: [patch] r8169: fix crash when large packets are received
References: <4A2D8B8B.80905@gmail.com>	<1244511638.30733.41.camel@localhost.localdomain> <20090608.195709.158667574.davem@davemloft.net>
In-Reply-To: <20090608.195709.158667574.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jon Masters <jonathan@jonmasters.org>
> Date: Mon, 08 Jun 2009 21:40:38 -0400
> 
>> CC -stable team - remote DoS with this hardware present.
> 
> "remote", if on the same physical subnet, otherwise easily protectable
> if not impossible to trigger

"remote" as "from outside of the host in question".
But still, this is definitely worth fixing.

Thanks.

/mjt
