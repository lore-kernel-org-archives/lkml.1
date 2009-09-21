Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZIUOo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZIUOo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZIUOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:44:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386AbZIUOoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:44:25 -0400
Date: Mon, 21 Sep 2009 16:43:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, jbenc@suse.cz,
       jkosina@suse.cz, johannes@sipsolutions.net, sandro.bonazzola@gmail.com
Subject: Re: [PATCH 2/2] w35und: Fix ->configure_filter breakage
Message-ID: <20090921144332.GA2690@elf.ucw.cz>
References: <1253526736.5216.8.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253526736.5216.8.camel@penberg-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Commit 3ac64beecd27400d12cc7afb4108eef26c499f6a ("mac80211: allow
> configure_filter callback to sleep") ->configure_filter function
> signature. Fix driver breakage by introducing a ->prepare_multicast
> operation that returns "mc_count". I'm not sure if the "mc_count > 32"
> check is actually needed but lets keep the driver functionally
> equivalent for now.
> 
> Cc: Greg KH <greg@kroah.com>
> Cc: Jiri Benc <jbenc@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Pavel Machek <pavel@ucw.cz>

Ack.. And thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
