Return-Path: <linux-kernel-owner+w=401wt.eu-S935824AbZLPWij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935824AbZLPWij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935175AbZLPWif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:38:35 -0500
Received: from khc.piap.pl ([195.187.100.11]:43443 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935463AbZLPWid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:38:33 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jean Delvare <jdelvare@suse.de>, Dave Airlie <airlied@linux.ie>,
       Jeff Mahoney <jeffm@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
	<200912131250.13797.jdelvare@suse.de>
	<alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
	<200912161437.32134.jdelvare@suse.de>
	<20091216100005.2c7e6d69@jbarnes-piketon>
Date: Wed, 16 Dec 2009 23:38:29 +0100
In-Reply-To: <20091216100005.2c7e6d69@jbarnes-piketon> (Jesse Barnes's message
	of "Wed, 16 Dec 2009 10:00:05 -0800")
Message-ID: <m34onq1r4q.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> Actually, that's one of the big advantages of the KMS based driver.  It
> *does* transparently pick the native resolution of the detected
> output(s) and set up a high res console.  You can provide boot options
> to override it, but unlike intelfb, boot options aren't necessary to
> get things working in the first place.

How do I set the (default) resolution and timings with non-EDID display
(e.g. analog RGB TV)?

fbset seems to only set the "logical" resolution, doesn't like the
pixclock.
-- 
Krzysztof Halasa
