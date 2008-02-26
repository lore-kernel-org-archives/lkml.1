Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYBZANl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYBZANl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbYBZANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:13:30 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:23366 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYBZAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:13:29 -0500
Message-ID: <47C35999.7090307@chelsio.com>
Date: Mon, 25 Feb 2008 16:13:13 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, krkumar2@in.ibm.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [git patches] net driver updates
References: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com><20080220.214651.235108740.davem@davemloft.net><8A71B368A89016469F72CD08050AD334026D6511@maui.asicdesigners.com> <20080220.221554.128587906.davem@davemloft.net> <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com> <47C34838.3040502@garzik.org>
In-Reply-To: <47C34838.3040502@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2008 00:12:19.0062 (UTC) FILETIME=[401CA960:01C8780C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> So, it sounds like Krishna's patch is ok, because the race does not 
> exist anymore in this driver?
The first part is right indeed, but the second part is breaking the 
current usage of txq_stopped and
the logic that stops and restarts the Tx queue.
I can submit a patch fixing it. Plese let me know what's more convenient 
for you.

Cheers,
Divy
