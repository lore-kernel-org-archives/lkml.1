Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZL3MEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZL3MEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZL3MEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:04:43 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:56551 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZL3MEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:04:42 -0500
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Luke-Jr <luke@dashjr.org>
Cc: Kalle Valo <kalle.valo@iki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
In-Reply-To: <200912300302.29725.luke@dashjr.org>
References: <200912290152.16357.luke@dashjr.org>
	 <200912292110.42122.luke@dashjr.org> <87pr5xvslk.fsf@purkki.valot.fi>
	 <200912300302.29725.luke@dashjr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 14:04:33 +0200
Message-ID: <1262174673.28789.188.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-12-30 at 03:02 -0600, Luke-Jr wrote:
> On Wednesday 30 December 2009 01:17:11 am Kalle Valo wrote:
> > "Luke-Jr" <luke@dashjr.org> writes:
> > > On that topic, is there a reason the newer code is under a unified "N8x0"
> > > config option instead of the split N800/N810 that was used for the old
> > > code, or is that simply a symptom of the currently-supported features all
> > > being common?
> > 
> > IIRC, I just used one common n8x0 file because the n810 board file was
> > very small and I didn't see any benefit from having it separately.
> 
> Yeah, that's because someone put all the N810 code in the N800 file ;)
> 
> Will probably at least split out the differences, if there's no other reason, 
> then. Since I'm doing this stuff only for my own personal interest, I'll 
> probably not bother to do much with N800 support unless someone feels like 
> sending me one when I finish N810 (definitely not touching N800 before then).

I think it's not worth the effort. Those boards share a lot of code.
You'll end up with several small board files

-- 
balbi

