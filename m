Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZJJDmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZJJDmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 23:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZJJDmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 23:42:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60204
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbZJJDmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 23:42:35 -0400
Date: Fri, 09 Oct 2009 20:42:31 -0700 (PDT)
Message-Id: <20091009.204231.204042155.davem@davemloft.net>
To: Fred.L.Templin@boeing.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       contact@saschahlusiak.de, yoshfuji@linux-ipv6.org
Subject: Re: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
From: David Miller <davem@davemloft.net>
In-Reply-To: <12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
References: <20091009233411.852013234@mini.kroah.org>
	<20091009233440.786680001@mini.kroah.org>
	<12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
Date: Fri, 9 Oct 2009 17:34:49 -0700

> Wait a moment - I remember now that this code came
> from Yoshifuji, and I believe there was a reason for
> the cmax+1. The application is expected to know this
> and to post a large enough buffer.
> 
> Can we put this on hold until I have had a chance to
> check my e-mail archives and my local iproute changes
> (will respond on monday)?

Sure, we can keep it out of -stable for now.

But it is in Linus's tree so if you find we shouldn't do this
you'll need to send me a revert for net-2.6

Otherwise if it's good, you'll have to remind me to resubmit
it to -stable.

Thanks!
