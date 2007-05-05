Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXEERRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXEERRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbXEERRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:17:44 -0400
Received: from mx2.math.uh.edu ([129.7.128.33]:35900 "EHLO mx2.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbXEERRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:17:43 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 13:17:43 EDT
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
References: <200705041132.32227.rjw@sisk.pl>
	<20070504233135.4671cd98.akpm@linux-foundation.org>
From: Jason L Tibbitts III <tibbs@math.uh.edu>
Date: 05 May 2007 11:55:50 -0500
In-Reply-To: <20070504233135.4671cd98.akpm@linux-foundation.org>
Message-ID: <ufa1whvtdk9.fsf@epithumia.math.uh.edu>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AM" == Andrew Morton <akpm@linux-foundation.org> writes:

AM> This causes the long-suffering Vaio to fail to power off during
AM> suspend to disk.  It says "Please power me down manually".

Interesting; I'm seeing exactly the same thing on a Vaio TXN17P, which
popped up somewhere between Fedora's 2.6.21-1.2116 and 2.6.21-1.2125
kernels, but the changelog there shows little more than wireless fixes
and the 2.6.21.1 patch.

AM> However `halt -p' still works OK.

The same for me.  It's odd to think that identical symptoms are caused
by something completely different, but I guess this is the kernel.

 - J<
