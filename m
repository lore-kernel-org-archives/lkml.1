Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYHHHwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYHHHwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYHHHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:52:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2605 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783AbYHHHwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:52:21 -0400
Date: Fri, 8 Aug 2008 09:44:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080808074452.GA10657@ucw.cz>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Not all X drivers save and restore fonts on text VTs. Add code to the
> kernel to explicitly save and restore them on VT switches.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Signed-off-by: Ben Collins <ben.collins@canonical.com>


...plus fonts are lost over suspend/resume in vgacon case; I guess
this code could be reused for that?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
