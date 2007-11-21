Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXKUT6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXKUT6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXKUT6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:58:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:43444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXKUT6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:58:39 -0500
Subject: Re: radeonfb i2c regression post-2.6.18.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Dennis Munsie <dmunsie@cecropia.com>, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <87oddoaqa6.fsf@hardknott.home>
References: <1195427766.7022.18.camel@pasglop>
	 <87oddoaqa6.fsf@hardknott.home>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 06:58:09 +1100
Message-Id: <1195675089.6970.96.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Can you try the patch from Jean that I pasted below and let us know if
> > it helps ? It looks like the releasing of the i2c lines may have been
> > done backward.
> 
> This patch fixes the problem.  The monitor stays powered on during the
> switch to the framebuffer.

Excellent ! That saves me having to test myself :-)

As far as I'm concerned, that's an Ack for the patch.

Ben.


