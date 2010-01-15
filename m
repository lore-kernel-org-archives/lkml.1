Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0AOIN4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411Ab0AOINz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:13:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46459 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0AOINz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:13:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B5023A6.5070100@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 09:13:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Julia Lawall <julia@diku.dk>, N??meth M??rton <nm127@freemail.hu>,
        David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality (was Re: [PATCH] uwb: make USB device id constant)
References: <4B4C297A.5090405@freemail.hu> <4B4C9ED9.60905@csr.com> <4B4CAA15.4030200@freemail.hu> <4B4DDFDB.2000408@s5r6.in-berlin.de> <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk> <20100115010315.GA29093@hexapodia.org>
In-Reply-To: <20100115010315.GA29093@hexapodia.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson wrote:
> For example, look at 5d66fe92.  The semantic patch is blissfully,
> incredibly clear.  It makes the sun shine down through the clouds, the
> birds sing, and the kzalloc align.  It's 10 lines long and is quite
> intuitive and explanatory.  In that case, I think it's clear that the
> spatch is worth the changelog space it takes up, even though the
> changelog is larger than the diff by quite a margin.

5d66fe92 is another example of what I was talking about.  The changelog
could have read:

	drivers/net : Correct the size argument to kzalloc

	lp->rx_skb is for an array of pointers, not of structs.
	Found using coccinelle.

	Signed-off-by: ...

Tell me again in what way the script is of any importance or of any help
in the permanent SCM changelog after commit.

I agree with you that it is very good to have the script in the patch
posting, but I disagree about the changelog.
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
