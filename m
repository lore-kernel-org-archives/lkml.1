Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874Ab0AEVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0AEVkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232Ab0AEVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:40:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34910
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504Ab0AEVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:40:34 -0500
Date: Tue, 05 Jan 2010 13:40:38 -0800 (PST)
Message-Id: <20100105.134038.21223965.davem@davemloft.net>
To: mst@redhat.com
Cc: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100105205040.GA30921@redhat.com>
References: <20100105185732.GA30346@redhat.com>
	<4B439299.1090205@gmail.com>
	<20100105205040.GA30921@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 5 Jan 2010 22:50:40 +0200

> binding socket to device might be done by a separate process
> from the one doing sendmsg, and IMO the device socket is bound
> to might change at any time.
> 
> So the sending process would need to get socket name before
> each sendmsg.
> 
> Makes sense?

Not really, when it's at the expense of everyone else.

If you can pass the FD around, you can pass around auxiliary
information as well.

Make sense? :-)


