Return-Path: <linux-kernel-owner+w=401wt.eu-S933927AbXK2W3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbXK2W3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761832AbXK2W2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:28:54 -0500
Received: from stinky.trash.net ([213.144.137.162]:58459 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760977AbXK2W2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:28:53 -0500
Message-ID: <474F3D04.1020000@trash.net>
Date: Thu, 29 Nov 2007 23:28:20 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, stable@kernel.org
Subject: Re: [PATCH] Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
References: <Pine.LNX.4.64.0711292314110.3089@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0711292314110.3089@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
>
>
> When xt_CONNMARK is used outside the mangle table and the user specified
> "--restore-mark", the connmark_tg_check() function will (correctly)
> error out, but (incorrectly) forgets to release the L3 conntrack module.
> Same for xt_CONNSECMARK.
> Fix is to move the call to acquire the L3 module after the basic 
> constraint checks.
>   

Applied, thanks Jan.

