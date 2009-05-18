Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZERDkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZERDkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZERDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:39:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59841
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbZERDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:39:55 -0400
Date: Sun, 17 May 2009 20:39:53 -0700 (PDT)
Message-Id: <20090517.203953.162821389.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ipconfig: handle case of delayed DHCP server
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A08640D.7020100@nortel.com>
References: <m17i0pwg0w.fsf@fess.ebiederm.org>
	<20090510.010821.00122250.davem@davemloft.net>
	<4A08640D.7020100@nortel.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Mon, 11 May 2009 11:44:45 -0600

> If a DHCP server is delayed, it's possible for the client to receive the 
> DHCPOFFER after it has already sent out a new DHCPDISCOVER message from 
> a second interface.  The client then sends out a DHCPREQUEST from the 
> second interface, but the server doesn't recognize the device and 
> rejects the request.
> 
> This patch simply tracks the current device being configured and throws 
> away the OFFER if it is not intended for the current device.  A more 
> sophisticated approach would be to put the OFFER information into the 
> struct ic_device rather than storing it globally.
> 
> Signed-off-by: Chris Friesen <cfriesen@nortel.com>

Applied, thanks Chris.
