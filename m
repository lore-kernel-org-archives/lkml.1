Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbXGMJHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbXGMJHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933378AbXGMJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:07:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933003AbXGMJHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:07:07 -0400
Date: Fri, 13 Jul 2007 02:06:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 0/4] Cell SPE logos
Message-Id: <20070713020621.e8f2e4ce.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
	<20070712160621.644d78d2.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 10:52:10 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> > > Summaries:
> > >   [1] fbdev: extract fb_show_logo_line()
> > >   [2] fbdev: Add fb_append_extra_logo()
> > 
> > This one does give additional code and data to all fbdev users while only
> > being useful to cell machines.  Should we fix that?
> 
> I can protect it by #ifdef CONFIG_PPC_CELL (as long as there are no other
> users). Would that be OK?

umm, your call.  If that makes sense, sure.
