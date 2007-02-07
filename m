Return-Path: <linux-kernel-owner+w=401wt.eu-S1422734AbXBGVCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422734AbXBGVCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422737AbXBGVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:02:05 -0500
Received: from mail.macqel.be ([194.78.208.39]:5490 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422734AbXBGVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:02:04 -0500
Date: Wed, 7 Feb 2007 22:02:01 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Joe Perches <joe@perches.com>, kkeil@suse.de, kai.germaschewski@gmx.de,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070207210201.GA4427@ingate.macqel.be>
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost> <20070206204130.GU8991@Ahmed> <20070206211813.GD2649@ingate.macqel.be> <20070207194059.GY8991@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207194059.GY8991@Ahmed>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 09:41:00PM +0200, Ahmed S. Darwish wrote:
> On Tue, Feb 06, 2007 at 10:18:14PM +0100, Philippe De Muyter wrote:
> > On Tue, Feb 06, 2007 at 10:41:30PM +0200, Ahmed S. Darwish wrote:
> > >  
> > > -    for (i=nelem-1; i >= 0; i--) {
> > > +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
> > 
> > I would write such decrementing loops as :
> > 
> >        for (i = ARRAY_SIZE(procfsentries); --i >= 0; ) {
> > 
> > Long time ago, that produced better code.  I did not check recently though.
> [...]
> > > -    for (i=nelem-1; i >= 0; i--) {
> > > +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
> > 
> > Same here
> 
> Hi Philippe,
> 
> Won't this hurt readability ?. I'm not a gcc guru anyway to have an
> opinion on such stuff :).

Personaly, I find it more readable, but that's a question of habit or a
matter of taste.

Philippe
