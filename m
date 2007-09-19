Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXISD7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXISD7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXISD73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:59:29 -0400
Received: from gw.goop.org ([64.81.55.164]:38266 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXISD72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:59:28 -0400
Message-ID: <46F09EA1.7060606@goop.org>
Date: Tue, 18 Sep 2007 20:59:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
References: <1189747054.7262.34.camel@localhost.localdomain> <200709181257.41530.ak@suse.de> <1190151272.7262.175.camel@localhost.localdomain> <200709182352.25118.ak@suse.de>
In-Reply-To: <200709182352.25118.ak@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> At least the Xen port seems to have specific requirements
> and essentially only work on xen-unstable (?) [or at least
> some very new Xen version] which probably very few
> people use.
>   

Only on 64-bit hosts, because of bugs in the 64-bit compat layer. 
32-on-32 and 64-on-64 (when its done) should work fine.

BTW, what does "xm info" say on your system that fails?  I'll try to put
a more graceful failure in there.

    J
