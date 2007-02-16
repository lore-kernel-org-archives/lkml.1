Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXBPRqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXBPRqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbXBPRqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:46:08 -0500
Received: from gw.goop.org ([64.81.55.164]:57402 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbXBPRqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:46:07 -0500
Message-ID: <45D5EDDB.7050404@goop.org>
Date: Fri, 16 Feb 2007 09:46:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Andrew Morton <akpm@linux-foundation.org>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Christian Limpach <Christian.Limpach@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Steven Hand <steven.hand@cl.cam.ac.uk>,
       Ian Pratt <Ian.Pratt@xensource.com>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disableunsupported config options.
References: <C1FB3FEA.98F7%keir@xensource.com>
In-Reply-To: <C1FB3FEA.98F7%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> This initial patchset does not include save/restore support anyway, so in
> fact it would be consistent to have CONFIG_PREEMPT configurable. I'm sure
> that we are going to have some nasty bugs to fix up as a result, but we
> can't fix them until we find them! Then we can convert our save/restore code
> to use the freezer before submitting it for inclusion.
OK.  So that makes the only config restriction the 100Hz ticks.

    J
