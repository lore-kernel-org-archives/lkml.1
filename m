Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXKUUSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXKUUSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXKUUSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:18:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:41167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbXKUUSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:18:13 -0500
Subject: Re: radeonfb i2c regression post-2.6.18.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michael Buesch <mb@bu3sch.de>
Cc: Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Dennis Munsie <dmunsie@cecropia.com>
In-Reply-To: <200711212113.19450.mb@bu3sch.de>
References: <1195427766.7022.18.camel@pasglop>
	 <87oddoaqa6.fsf@hardknott.home> <1195675089.6970.96.camel@pasglop>
	 <200711212113.19450.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 07:17:57 +1100
Message-Id: <1195676277.6970.102.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-21 at 21:13 +0100, Michael Buesch wrote:
> On Wednesday 21 November 2007 20:58:09 Benjamin Herrenschmidt wrote:
> > 
> > > > Can you try the patch from Jean that I pasted below and let us know if
> > > > it helps ? It looks like the releasing of the i2c lines may have been
> > > > done backward.
> > > 
> > > This patch fixes the problem.  The monitor stays powered on during the
> > > switch to the framebuffer.
> > 
> > Excellent ! That saves me having to test myself :-)
> > 
> > As far as I'm concerned, that's an Ack for the patch.
> 
> I'll test tomorrow if that also fixes my problem.
> You'll hear from me.

Thanks Michael !

Cheers,
Ben.


