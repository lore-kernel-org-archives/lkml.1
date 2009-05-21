Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZEUTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZEUTeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZEUTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:34:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50569
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbZEUTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:34:05 -0400
Date: Thu, 21 May 2009 12:34:03 -0700 (PDT)
Message-Id: <20090521.123403.13286908.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-hotplug@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fenlason@redhat.com
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
From: David Miller <davem@davemloft.net>
In-Reply-To: <tkrat.21c425cc195510c9@s5r6.in-berlin.de>
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Thu, 21 May 2009 15:29:10 +0200 (CEST)

> Change the initial name of IP-over-1394 networking interfaces from
> "eth[0-9]+" to "firewire[0-9]+".
> 
> This should have been done years ago for the reason mentioned in the
> inline comment.  The naming issue basically prevented acceptance of
> IP networking over 1394 on Linux.
> 
> The future IP-over1394 driver in the newer alternative firewire driver
> stack will use the "firewire%d" format from the start while "eth%d" will
> no longer be used in the new driver.
> 
> Necessary changes in userland:
> 
> People who use the eth1394 driver either have to update their network
> configuration (or instead perhaps respecpective udev interface renaming
> rules) to the new names, or add
> 
>     options eth1394 firewire_interface_name=N
> 
> to /etc/modprobe.conf or /etc/modprobe.d/whatever if they really prefer
> the old names.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

I think the basis for this patch is completely bogus.

Device names are just that, names.  If you want to know "what it is"
or "where it is" you use tools to determine that information.

If you make ethtool's get info command return something useful,
then the user can see that it's a firewire interface and act
accordingly, as can sophisticated confiruation applications.

I am completely against this patch.
