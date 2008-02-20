Return-Path: <linux-kernel-owner+w=401wt.eu-S1763694AbYBTWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763694AbYBTWha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYBTWhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:37:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56948 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYBTWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:37:16 -0500
Date: Wed, 20 Feb 2008 14:36:54 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080220143654.20ae7bea@laptopd505.fenrus.org>
In-Reply-To: <1203543869.6243.106.camel@lappy>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<1203531375.6243.52.camel@lappy>
	<20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	<1203533622.6243.55.camel@lappy>
	<20080220112655.18011dab@laptopd505.fenrus.org>
	<1203541122.6243.103.camel@lappy>
	<20080220130736.4ccb2687@laptopd505.fenrus.org>
	<1203543869.6243.106.camel@lappy>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 22:44:29 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Wed, 2008-02-20 at 13:07 -0800, Arjan van de Ven wrote:
> > On Wed, 20 Feb 2008 21:58:42 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > 
> > > On Wed, 2008-02-20 at 11:26 -0800, Arjan van de Ven wrote:
> > > 
> > > > feel free to reinvent a whole GUI just to avoid a 200 line
> > > > kernel module. sysprof is here. it works. 
> > > 
> > > > the gui is REALLY nice.
> > > 
> > > I guess we have to agree to disagree here. Its plain useless from
> > > my POV.
> > 
> > that's fine. Different tools for different people. sysprof isn't
> > aimed at kernel developers.
> 
> That was speaking from userland days.
> 
> But you forgot the more important points about API and wild-growth of
> duplicate interfaces.

yes there's multiple interfaces. There are multiple interfaces *today*.
Oprofile/perfmon2 are very focused on CPU events and have complex interfaces,
sysprof has a much more simple interface (and yes, very specific to syspref)
that just focuses on samples.

Sadly, I think there's use for both, and forcing both into the same straightjacket is a mistake imo.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
