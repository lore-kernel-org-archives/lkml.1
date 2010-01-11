Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026Ab0AKK4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0AKK4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AKK4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:56:23 -0500
Received: from stinky.trash.net ([213.144.137.162]:59954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0AKK4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:56:21 -0500
Message-ID: <4B4B03CF.8050004@trash.net>
Date: Mon, 11 Jan 2010 11:56:15 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "David S. Miller" <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/netfilter/xt_osf.c: Change %pi4 to %pI4
References: <1262830818.1872.52.camel@Joe-Laptop.home>
In-Reply-To: <1262830818.1872.52.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> commit 8a27f7c90ffcb791eed7574922b51fb60b08fc89
> changed the output style of %pi4 to use fixed
> width leading zero IP addresses "001.002.003.004".
> 
> It's useful when printing multiple lines of
> addresses, but was a change in output style for
> some existing uses.
> 
> Using %pI4 restores the previous output style.

Applied, thanks.
