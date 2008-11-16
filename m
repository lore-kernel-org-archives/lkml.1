Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYKPQwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYKPQwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYKPQvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:51:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59557 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbYKPQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:51:52 -0500
Date: Sun, 16 Nov 2008 17:51:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Philipp Kohlbecher <xt28@gmx.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: alternative identifier for Phoenix BIOS
Message-ID: <20081116165141.GA1534@ucw.cz>
References: <491EEDE8.5080508@gmx.de> <491F7D88.7080403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491F7D88.7080403@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-15 17:55:20, H. Peter Anvin wrote:
> Philipp Kohlbecher wrote:
> > My laptop (a Samsung X20) contains a Phoenix BIOS and would benefit from
> > patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: reserve low 64K on
> > AMI and Phoenix BIOS boxen).
> > 
> > However, according to /sys/class/dmi/id/bios_vendor, the BIOS identifies
> > its vendor as "Phoenix Technologies LTD" (sans the comma).
> 
> Given that AMI and Phoenix combined is something like 80% of the BIOS
> market, if not more, it might simply be easier to make it unconditional,
>  or make it a whitelist instead.

Whitelist is bad:

even if bios vendor is a good boy and tests their bios with linux,
they will not notice that they corrupt low 64K (not whitelisted), and
will not fix their bios.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
