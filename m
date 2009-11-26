Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZKZQoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZKZQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZKZQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:44:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbZKZQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:44:11 -0500
Date: Thu, 26 Nov 2009 17:44:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 7/7] kfifo: add record handling functions
Message-ID: <20091126164414.GK29096@one.firstfloor.org>
References: <1258704942.4426.5.camel@wall-e> <1258705988.4426.22.camel@wall-e> <20091123141914.e320c341.akpm@linux-foundation.org> <1259251632.26705.17.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259251632.26705.17.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 05:07:12PM +0100, Stefani Seibold wrote:
> I analyzed the code and most of them will be optimized away by the
> compiler. The reason for this design decision was that i want no
> performance regression against the old kfifo implementation.
> 
> But if the majority vote for an non inline version i will do it. It will
> make the code more readable and slim down the footprint.

I vote for smaller text size if possible. I doubt kfifo is used in any 
circumstances where a function call or two is a big problem. But of course
some inlines might be smaller than calls.

But then this code has been pending for a long time and I
have some potential users. It would be good to merge ASAP and do such tweaks 
later in tree.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
