Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbZHERWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbZHERWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934735AbZHERWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:22:42 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57358 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934728AbZHERWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:22:41 -0400
Date: Wed, 5 Aug 2009 19:22:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, - Cortez - <omegamoon@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel@jasper.es
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
Message-ID: <20090805172238.GM13236@buzzloop.caiaq.de>
References: <20090704024416.GA1345@ucw.cz> <20090715002445.GB2360@ucw.cz> <1f96a3530907200711h1e08bfb5k7123491cf688d9b1@mail.gmail.com> <4A64823C.2040601@gmail.com> <1f96a3530907201350n209483a5va803235536d241d0@mail.gmail.com> <4A651A8E.5070407@gmail.com> <20090805163036.GJ13236@buzzloop.caiaq.de> <1249492113.9324.369.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249492113.9324.369.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:08:33PM +0100, David Woodhouse wrote:
> On Wed, 2009-08-05 at 18:30 +0200, Daniel Mack wrote:
> > 
> > That bug hit me as well, and as in Cortez' case, reverting 15bce40
> > fixed
> > it for me on a PXA3xx platform.
> 
> Can you confirm that the fix in the mtd-2.6.git tree is sufficient?

Yep, thanks!

