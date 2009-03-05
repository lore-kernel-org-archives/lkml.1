Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZCEJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZCEJ63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZCEJ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:58:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45327
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbZCEJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:58:17 -0500
Date: Thu, 05 Mar 2009 01:58:02 -0800 (PST)
Message-Id: <20090305.015802.222446908.davem@davemloft.net>
To: kaber@trash.net
Cc: blaschka@linux.vnet.ibm.com, bart@jukie.net, greearb@candelatech.com,
       shemminger@vyatta.com, dada1@cosmosbay.com, frank.blaschka@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <49AF96BE.1020302@trash.net>
References: <20090305.005934.130220849.davem@davemloft.net>
	<49AF9672.50200@trash.net>
	<49AF96BE.1020302@trash.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 05 Mar 2009 10:09:18 +0100

> Patrick McHardy wrote:
> > Yes, but that patch introduced the requirement to pass the correct
> > device down since now the handlers need it to get to the ops of the
> > underlying device. Previously they all relied on the handlers not
> > using their private data.

Aha, that's right.

> > Signed-off-by: Patrick McHardy <kaber@trash.net>
> >   
> 
> Oops, the last patch was broken.

Applied, thanks!
