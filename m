Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbZLPW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbZLPW5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762909AbZLPW5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:57:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36730 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbZLPW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:57:36 -0500
Date: Wed, 16 Dec 2009 22:57:29 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jean Delvare <jdelvare@suse.de>,
       Jeff Mahoney <jeffm@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
In-Reply-To: <m34onq1r4q.fsf@intrepid.localdomain>
Message-ID: <alpine.DEB.2.00.0912162255501.25055@skynet.skynet.ie>
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com> <200912131250.13797.jdelvare@suse.de> <alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie> <200912161437.32134.jdelvare@suse.de> <20091216100005.2c7e6d69@jbarnes-piketon>
 <m34onq1r4q.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > Actually, that's one of the big advantages of the KMS based driver.  It
> > *does* transparently pick the native resolution of the detected
> > output(s) and set up a high res console.  You can provide boot options
> > to override it, but unlike intelfb, boot options aren't necessary to
> > get things working in the first place.
> 
> How do I set the (default) resolution and timings with non-EDID display
> (e.g. analog RGB TV)?
> 
> fbset seems to only set the "logical" resolution, doesn't like the
> pixclock.

Currently with the command line video=, this isn't optimal but still
nobody has come up with a way to make fbset useful since it can't deal
with multiple heads.

also the old intelfb didn't deal with analog rgb tv at all.

Dave.
