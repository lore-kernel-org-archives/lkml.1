Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZBRBlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZBRBlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbZBRBkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:40:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47214
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756489AbZBRBkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:40:13 -0500
Date: Tue, 17 Feb 2009 17:39:57 -0800 (PST)
Message-Id: <20090217.173957.140516246.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: bhutchings@solarflare.com, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/43] drivers/net/sfc: fix sparse warnings: Should it
 be static?
From: David Miller <davem@davemloft.net>
In-Reply-To: <154e089b0902160138n255616a0xb963dfd990d912b@mail.gmail.com>
References: <20090214214111.24377.87888.stgit@vmbox.hanneseder.net>
	<20090216003718.GN15266@solarflare.com>
	<154e089b0902160138n255616a0xb963dfd990d912b@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 16 Feb 2009 10:38:26 +0100

> On Mon, Feb 16, 2009 at 1:37 AM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > This is wrong.  The entire file is conditional on CONFIG_SFC_MTD.
> 
> Even better than. It's actually not wrong, just done twice, so we can
> omit it, thank you Ben. I'll send an update.

Ok, I'll skip over this patch.
