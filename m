Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbXLZE4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbXLZE4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 23:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXLZEzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 23:55:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXLZEzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 23:55:50 -0500
Date: Tue, 25 Dec 2007 20:55:43 -0800 (PST)
Message-Id: <20071225.205543.240106823.davem@davemloft.net>
To: horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, apw@us.ibm.com
Subject: Re: [patch] ipv4: Update ip command line processing (take II)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071226025903.GB14422@verge.net.au>
References: <20071226025903.GB14422@verge.net.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Wed, 26 Dec 2007 11:59:05 +0900

> Recently the documentation in Documentation/nfsroot.txt was
> update to note that in fact ip=off and ip=::::::off as the
> latter is ignored and the default (on) is used.
> 
> This was certainly a step in the direction of reducing confusion.
> But it seems to me that the code ought to be fixed up so that
> ip=::::::off actually turns off ip autoconfiguration.
> 
> This patch also notes more specifically that ip=on (aka ip=::::::on)
> is the default.
> 
> Cc: Amos Waterland <apw@us.ibm.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>

I applied this to net-2.6 since I think it's a bug fix, and
I also tailored the changelog header to more it clear this
is a fix not just an "Update". :-)

Thanks!

