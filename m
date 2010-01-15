Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0AOIvR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828Ab0AOIvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:51:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46742 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0AOIvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:51:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B502C6B.7000802@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 09:50:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
References: <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>	<20100115010315.GA29093@hexapodia.org>	<4B5023A6.5070100@s5r6.in-berlin.de> <20100115.002424.100105244.davem@davemloft.net>
In-Reply-To: <20100115.002424.100105244.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> And likewise here, I want to see what the hell found the bug by
> reading the changelog message.

Coccinelle found it.  In contrast to parsers like sparse, it had to be
programmed to do so.  If you want to repeat that process, you have to
get coccinelle and the script.  Both can be found quickly without having
them both in the SCM.

> I want more information in changelog messages, not less.  A commit
> log message is never too long and never gives too much information
> about the change, ever...

If the changelog carries a lot of unimportant or even unrelated
information, then only a careful structure of the text can prevent that
the important information is buried in noise, and thus lost.  (Julia's
logs are structured respectively, so this is OK.)
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
