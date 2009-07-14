Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZGNWxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZGNWxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZGNWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:53:40 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:49524 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756179AbZGNWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:53:39 -0400
Date: Tue, 14 Jul 2009 23:53:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-i2c@vger.kernel.org, linus.walleij@stericsson.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers/i2c: Use resource_size
Message-ID: <20090714225320.GA10277@fluff.org.uk>
References: <Pine.LNX.4.64.0907050837160.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907050837160.27464@ask.diku.dk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 08:37:50AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use the function resource_size, which reduces the chance of introducing
> off-by-one errors in calculating the resource size.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> struct resource *res;
> @@
> 
> - (res->end - res->start) + 1
> + resource_size(res)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

I'll class these as fixes and have applied them to my
tree for linus.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
