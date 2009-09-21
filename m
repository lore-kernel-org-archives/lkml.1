Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZIUTV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZIUTV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZIUTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:21:19 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60344 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZIUTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sfSh105wg+J7HtKcDIEg8GqiMZARB1WS117qYkuo70C+OwLgQvEJWc21/UEK9+R4E/
         lK/TjuISoZ9EN9MHbLC8th2ekHA93/Z8Ep/p5FFKKidHb7wLR9mYaSZLLwuDRJZB1WIK
         KKMgFXGnny7O/HmmixgG+W/GdCXOcEd/Ko5yo=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: "cfg80211: fix SME connect" breaks iwl3945
Date: Mon, 21 Sep 2009 21:14:06 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-wl; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, johannes@sipsolutions.net,
       netdev@vger.kernel.org
References: <20090921190150.GC23126@kernel.dk>
In-Reply-To: <20090921190150.GC23126@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909212114.06642.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 September 2009 21:01:50 Jens Axboe wrote:
> Since the latest net pull that contains our above commit
> (bbac31f4c0339f6c51afbd0edfb4959df9b53fa9 in tree), my iwl3945 based x60
> laptop doesn't want to connect to my access point at all. Reverting this
> commit makes it work.
> 
> Let me know if you need more info.

Can you try "[PATCH] cfg80211: don't overwrite privacy setting" 
from [1]?

[1] http://marc.info/?l=linux-wireless&m=125323296617306&w=2

Regards,
	Chr
