Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXIKMTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXIKMTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXIKMTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:19:02 -0400
Received: from khc.piap.pl ([195.187.100.11]:56115 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbXIKMTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:19:00 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sylvain.meyer@worldonline.fr, <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Intel FB pixel clock calculation fix
References: <m3ir6il3wl.fsf@maximus.localdomain>
	<20070910225221.f0eaf22c.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 11 Sep 2007 14:18:57 +0200
In-Reply-To: <20070910225221.f0eaf22c.akpm@linux-foundation.org> (Andrew Morton's message of "Mon, 10 Sep 2007 22:52:21 -0700")
Message-ID: <m3veah75u6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> Intel framebuffer mis-calculated pixel clocks.

> and... what are the consequences of this miscalculation?  I need to know
> such things so that I can decide whether a change is needed in 2.6.23.  And
> 2.6.22.

The pixel clock (and thus both H and V sync) will be slower than
requested, so if you set the minimum allowed the display may not
sync. In case of really old CRT display it could theoretically
damage it.

I'm using it with PAL TV (using RGB input - SCART connector) and
the bug prevented it from working at all (TV requirements are more
strict and made the bug visible).

I think 2.6.22 would be overkill, .23 - not sure.
-- 
Krzysztof Halasa
