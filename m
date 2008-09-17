Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYIQOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYIQOa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYIQOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:30:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48704 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYIQOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:30:18 -0400
Date: Wed, 17 Sep 2008 10:29:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917142931.GF5407@tuxdriver.com>
References: <48CFC03A.8020708@lwfinger.net> <200809162125.18978.mb@bu3sch.de> <20080916223729.GC26035@khazad-dum.debian.net> <200809171626.28782.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809171626.28782.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 04:26:28PM +0200, Michael Buesch wrote:
> On Wednesday 17 September 2008 00:37:29 Henrique de Moraes Holschuh wrote:
> > On Tue, 16 Sep 2008, Michael Buesch wrote:
> > > But I don't know how to tell the rfkill subsystem about the states and
> > 
> > rfkill_force_state().  Must NOT be called from within atomic contextes,
> > something I haven't got around to find a proper way of fixing, and nobody
> > else seems to be on a rfkill coding frenzy right now.
> 
> That's a showstopper for us, as we have to change the state from
> within an interrupt tasklet.

Workqueue?

-- 
John W. Linville
linville@tuxdriver.com
