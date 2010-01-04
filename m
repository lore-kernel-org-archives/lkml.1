Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453Ab0ADOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0ADOX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432Ab0ADOX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:23:27 -0500
Received: from stinky.trash.net ([213.144.137.162]:34970 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0ADOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:23:25 -0500
Message-ID: <4B41F9DB.1010908@trash.net>
Date: Mon, 04 Jan 2010 15:23:23 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       coreteam@netfilter.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] net/ipv4 : Correct the size argument to kzalloc
References: <Pine.LNX.4.64.0912292016230.4001@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912292016230.4001@ask.diku.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> obj has type struct snmp_object **, not struct snmp_object *.  But indeed
> it is not even clear why kmalloc is needed.  The memory is freed by the end
> of the function, so the local variable of pointer type should be sufficient.

Thanks. As this is basically just an unneeded and oversized allocation
without any bad consequences, I've applied it to nf-next-2.6.git.


