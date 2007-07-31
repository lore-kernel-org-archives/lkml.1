Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXGaMiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXGaMiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXGaMh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:37:59 -0400
Received: from mx12.go2.pl ([193.17.41.142]:44497 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847AbXGaMh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:37:58 -0400
Date: Tue, 31 Jul 2007 14:47:25 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, amitkale@linsyssoft.com
Subject: Re: NETPOLL=y , NETDEVICES=n compile error ( Re: 2.6.23-rc1-mm1 )
Message-ID: <20070731124725.GB1046@ff.dom.local>
References: <20070731083210.GA1797@ff.dom.local> <46AF0B8C.7070006@googlemail.com> <46AF20B4.4050203@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF20B4.4050203@windriver.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 06:44:52AM -0500, Jason Wessel wrote:
...
> kgdboe is completely useless without a network card that has a polling 
> driver.  It seems to me that the simple and easy fix is to set it to 
> depend on NETDEVICES but allow it to use select on NETPOLL.

Maybe I miss your point but polling drivers don't need NETPOLL
to work (unless you need netconsole). But I don't know if there
is any easy method to check such driver's dependency with select.

Jarek P.
