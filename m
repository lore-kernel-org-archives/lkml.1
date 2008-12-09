Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYLIXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYLIXs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYLIXsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:48:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50478
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYLIXso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:48:44 -0500
Date: Tue, 09 Dec 2008 15:48:45 -0800 (PST)
Message-Id: <20081209.154845.195219989.davem@davemloft.net>
To: jsembera@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: silence log messages for locally generated
 multicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081208122557.GB4498@alaris.suse.cz>
References: <20081208122557.GB4498@alaris.suse.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Sembera <jsembera@suse.cz>
Date: Mon, 8 Dec 2008 13:25:57 +0100

> This patch fixes minor annoyance during transmission of unsolicited
> neighbor advertisements from userspace to multicast addresses (as
> far as I can see in RFC, this is allowed and the similar functionality
> for IPv4 has been in arping for a long time).
> 
> Outgoing multicast packets get reinserted into local processing as if they
> are received from the network. The machine thus sees its own NA and fills
> the logs with error messages. This patch removes the message if NA has been
> generated locally.
> 
> Signed-off-by: Jan Sembera <jsembera@suse.cz>

Patch applied, thanks Jan.
