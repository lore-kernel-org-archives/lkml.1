Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZL1Blr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZL1Blr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZL1Blr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:41:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZL1Blq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:41:46 -0500
Date: Mon, 28 Dec 2009 02:41:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091228014141.GE2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e> <adahbrcyn1l.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahbrcyn1l.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 04:12:06PM -0800, Roland Dreier wrote:
> 
>  > I am not happy to see you to take over my project. Especial as most of
>  > your fixes are part of my new macro based implementation. Have a look at
>  > http://patchwork.kernel.org/patch/69093/
> 
> I don't really understand.  You spent a lot of time getting the kfifo
> stuff merged, and now you want to merge (quoting from that patch above)
> "a complete reimplementation of the new kfifo API"?
> 
> What happened here?  Couldn't you have done the reimplementation before
> merging?

I guess the reimplementation came too late (happens sometimes)
And I agree that making kfifos record oriented makes sense.

Still now that the old one is in we have to fix it at least
until there are no users left.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
