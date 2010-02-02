Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0BBOeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:34:25 -0500
Received: from stinky.trash.net ([213.144.137.162]:63716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0BBOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:34:22 -0500
Message-ID: <4B6837EB.3030902@trash.net>
Date: Tue, 02 Feb 2010 15:34:19 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Jan Engelhardt <jengelh@medozas.de>,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
References: <4B54CDE5.3070100@simon.arlott.org.uk> <4B5578A5.50705@gmail.com>    <dad314e12c5750b1b5d70c3ea3c6f6134b8fa0f3@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>    <4B55D372.4020807@gmail.com>    <710ab0ca79305c82013982d43250b0a1fd45824d@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>    <4B5773C2.2010000@simon.arlott.org.uk>    <alpine.LSU.2.01.1001202238400.18680@obet.zrqbmnf.qr>    <alpine.LSU.2.01.1001202240350.18680@obet.zrqbmnf.qr>    <4B578E59.8090203@trash.net> <0b01c450344abffd72a5b1b037ee6584e6db6b82@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid> <4B585079.1070904@trash.net> <4B58B578.9080505@simon.arlott.org.uk>
In-Reply-To: <4B58B578.9080505@simon.arlott.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> The TCPMSS target is dropping SYN packets where:
>   1) There is data, or
>   2) The data offset makes the TCP header larger than the packet.
> 
> Both of these result in an error level printk. This printk has been
> removed.
> 
> This change avoids dropping SYN packets containing data. If there
> is also no MSS option (as well as data), one will not be added
> because of possible complications due to the increased packet size.

Applied, thanks Simon.

