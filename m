Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXIHQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXIHQPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXIHQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:15:46 -0400
Received: from homer.mvista.com ([63.81.120.158]:47073 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXIHQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:15:46 -0400
Subject: Re: [PATCH] net: myri10ge: force select inet_lro
From: Daniel Walker <dwalker@mvista.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070908.012214.41650322.davem@davemloft.net>
References: <20070907202625.702755508@mvista.com>
	 <20070908.012214.41650322.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 08 Sep 2007 09:03:06 -0700
Message-Id: <1189267386.9688.28.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 01:22 -0700, David Miller wrote:
> From: Daniel Walker <dwalker@mvista.com>
> Date: Fri, 07 Sep 2007 13:26:25 -0700
> 
> > This driver uses the inet_lro facilities , but it doesn't force it
> > to be enabled .. Someone would have to know to enable inet_lro if
> > they select the driver .. 
> > 
> > Instead, just force INET_LRO if this driver is selected..
> > 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> I put this exact fix into the net-2.6.24 tree several days ago
> already, it's not nice that you didn't even bother checking.

Sorry..

> When I saw the response to the help@ address, I could almost predict
> that the myri10ge developers would not even check if net-2.6.24 had
> the issue cured already.
> 
> Therefore, your patch doesn't even apply to the tree where it is
> relevant.  That sucks.

Not sure what the help@ address is ? I'm just trying to fix problems I
find .. This problem is in -mm which is what I was using. The driver is
pretty obscure, and I just assumed not many people would be building it.
So I didn't check for fixes in git ..

Did your fix go to LKML ?

Daniel

