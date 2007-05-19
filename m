Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXESOI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXESOI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 10:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbXESOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 10:08:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58643 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016AbXESOIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 10:08:18 -0400
Date: Sat, 19 May 2007 16:09:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070519140916.GC23370@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705191555.49376.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 03:55:49PM +0200, Andi Kleen wrote:
> On Saturday 19 May 2007 15:32, Sam Ravnborg wrote:
> > Following section mismatch warnings were reported by Andrey Borzenkov:
> 
> In what configuration? I don't see this.
I assumed that enabling CONFIG_MTRR would be enough to trigger it but
that did not do it (CONFIG_MTRR is enabled in defconfig).

When I used the config posted by Andrey in: http://lkml.org/lkml/2007/5/19/61
I saw the warnings.

I did not look into what caused the warnings with Andrey's but
not with defconfig.

	Sam
