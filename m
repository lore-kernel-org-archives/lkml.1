Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYHHQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYHHQuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYHHQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:50:09 -0400
Received: from xes-mad.com ([216.165.139.214]:38149 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHHQuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:50:07 -0400
Subject: Re: [PATCHv3] leds-pca955x: Add proper error handling and fix
	bogus memory handling
From: Nate Case <ncase@xes-inc.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: rpurdie@rpsys.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0808080924560.16201@titan.stealer.net>
References: <1210972198.13845.540.camel@localhost.localdomain>
	 <alpine.LNX.1.10.0808080041460.16201@titan.stealer.net>
	 <alpine.LNX.1.10.0808080852000.16201@titan.stealer.net>
	 <alpine.LNX.1.10.0808080924560.16201@titan.stealer.net>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 11:49:30 -0500
Message-Id: <1218214170.21619.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 09:27 +0200, Sven Wegener wrote:
> Here's a slightly updated patch, with some changes I had forgotten.
> Shouldn't change the logic at all.
> 
> - Another 32 -> sizeof() conversion
> - Move the unregister code to where we also free the memory on failure
> 
> And one more
> 
> - cancel_work_sync() when unregistering on failure

This looks good to me.  I won't be able to test it until Monday though.

-- 
Nate Case <ncase@xes-inc.com>

