Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZBCF0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZBCF0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZBCF0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:26:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34447
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZBCF0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:26:36 -0500
Date: Mon, 02 Feb 2009 21:26:33 -0800 (PST)
Message-Id: <20090202.212633.224141775.davem@davemloft.net>
To: sam@ravnborg.org
Cc: andrew@walrond.org, jengelh@medozas.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090203045833.GA11639@uranus.ravnborg.org>
References: <20090202.132450.21504465.davem@davemloft.net>
	<20090202.132723.38842373.davem@davemloft.net>
	<20090203045833.GA11639@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 3 Feb 2009 05:58:33 +0100

> On Mon, Feb 02, 2009 at 01:27:23PM -0800, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Mon, 02 Feb 2009 13:24:50 -0800 (PST)
> > 
> > > I guess I'll put in the following hack for now:
> > > 
> > > diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
> > > index aeab2cb..82c4362 100644
> > 
> > Need to also update linux/Kbuild, here is an updated patch:
> 
> All headers are unifdeffed - so the Kbuild patch
> is not needed.

Thanks for the info but that's how I commited and pushed out
the fix already, and it doesn't hurt either :-)
