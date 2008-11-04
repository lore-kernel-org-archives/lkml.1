Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYKDWxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYKDWxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYKDWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:53:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50157
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbYKDWxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:53:07 -0500
Date: Tue, 04 Nov 2008 14:52:42 -0800 (PST)
Message-Id: <20081104.145242.112948002.davem@davemloft.net>
To: linux-kernel@blueteddy.net
Cc: daniel.blueman@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <49107543.5080207@blueteddy.net>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	<49107543.5080207@blueteddy.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hudson <linux-kernel@blueteddy.net>
Date: Tue, 04 Nov 2008 16:16:03 +0000

> Daniel J Blueman wrote:
> > Is it time to enable TCP ECN per default and get the benefits, since
> > router support has been around and known-about for really considerable
> > time?
> > Perhaps it should be a question of enabling it, and educating people
> > to disable it if they run into issues, since we'll probably be in the
> > same situation in 5 years...and it'll be some time before these
> > kernels hit devices/servers anyway.
> > Daniel
>
> Unfortunately I think you'll find there are sufficiently large
> numbers of broken SOHO routers out there that if you try this you'll
> cause a lot of problems.  The problems range from no connectivity to
> in a few extreme cases routers actually crashing or behaving in very
> unpredictable ways.  Here's one summary that got presented to the
> IETF about 18 months ago:
>
> http://www.ietf.org/proceedings/07mar/slides/tsvarea-3/sld6.htm

Another issue is that, even if we turn it on by default, it won't
be on for a significant number of network cards out there.

This is because TSO, which is on by default, doesn't support ECN
in many implementations.
