Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZIUTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZIUTUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZIUTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:20:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54272 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZIUTUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:20:32 -0400
Date: Mon, 21 Sep 2009 21:20:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, johannes@sipsolutions.net,
       netdev@vger.kernel.org
Subject: Re: "cfg80211: fix SME connect" breaks iwl3945
Message-ID: <20090921192035.GG23126@kernel.dk>
References: <20090921190150.GC23126@kernel.dk> <200909212114.06642.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909212114.06642.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21 2009, Christian Lamparter wrote:
> On Monday 21 September 2009 21:01:50 Jens Axboe wrote:
> > Since the latest net pull that contains our above commit
> > (bbac31f4c0339f6c51afbd0edfb4959df9b53fa9 in tree), my iwl3945 based x60
> > laptop doesn't want to connect to my access point at all. Reverting this
> > commit makes it work.
> > 
> > Let me know if you need more info.
> 
> Can you try "[PATCH] cfg80211: don't overwrite privacy setting" 
> from [1]?
> 
> [1] http://marc.info/?l=linux-wireless&m=125323296617306&w=2

Seems to bring the network back as well, it associates fine and gets a
dhcp address.

-- 
Jens Axboe

