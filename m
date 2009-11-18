Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZKRJJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZKRJJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZKRJJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:09:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51692 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZKRJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:09:12 -0500
Date: Wed, 18 Nov 2009 10:09:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091118090913.GA9505@basil.fritz.box>
References: <20091027.222814.137568780.davem@davemloft.net> <20091028.005342.60092591.davem@davemloft.net> <21d7e9970910291813u19cdd361u2facb864db58a712@mail.gmail.com> <200910301113.43174.arnd@arndb.de> <21d7e9970911171626m216d35ddu4c4c3189edfd37cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970911171626m216d35ddu4c4c3189edfd37cc@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Doing all these out-of-line hidden over here in a separate file just
> seems crazy,
> and I'm  having trouble wondering why ppl consider it a better idea at all.

The separate file is on the way out, the modern way is to use
->compat_ioctl in the driver itself. Near all drivers except
for a few exceptions like DRM put it into the same file.
I think you should just move the code  around in DRM too
and drop the separate file.

-Andi
