Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZBGGBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZBGGBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 01:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZBGGBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 01:01:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZBGGBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 01:01:05 -0500
Date: Fri, 06 Feb 2009 22:01:01 -0800 (PST)
Message-Id: <20090206.220101.239298299.davem@davemloft.net>
To: itvirta@iki.fi
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Soft lockup in sungem on Netra AC200 when switching interface
 up
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090206112902.GS4362@tango.lnet.fi>
References: <20090206112902.GS4362@tango.lnet.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilkka Virta <itvirta@iki.fi>
Date: Fri, 6 Feb 2009 13:29:02 +0200

> Looking at gem_do_start() and gem_open(), it seems that the only thing
> done while opening the device after the request_irq(), is a call to
> napi_enable().
> 
> I don't know what the ordering requirements are for the
> initialization, but I boldly tried to move the napi_enable() call
> inside gem_do_start() before the link state is checked and interrupts
> subsequently enabled, and it seems to work for me. Doesn't even break
> anything too obvious...
> 
> Any ideas on how this really should be fixed?

Actually your fix looks good, I'll apply this :-)

Thanks!
