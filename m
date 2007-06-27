Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbXF0M6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbXF0M6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbXF0M54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:57:56 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43319
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbXF0M5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:57:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Date: Wed, 27 Jun 2007 14:57:17 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706262021.51410.mb@bu3sch.de> <20070626224517.GG11115@waste.org>
In-Reply-To: <20070626224517.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271457.17709.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 00:45:18 Matt Mackall wrote:
> On Tue, Jun 26, 2007 at 08:21:51PM +0200, Michael Buesch wrote:
> > Don't use the word "quality", as people seem to think of
> > the entropy quality when hearing that word.
> 
> Why do I so often feel compelled to respond with "did you read what I
> wrote?" on this list?

Because you ignored my explanations.

> I object to your MEANINGLESS CATEGORIES.
> 
> > This uses the word "type", which is probably better for
> > understanding what the value really means.
> 
> Please explain:
> 
> a) how is bad different from pseudo?
> b) how is onboard different than dedicated?

Read the Kdoc help text in the patch. It explains it.

> I maintain that there are exactly two categories on this axis: real
> and fake. And I'd rather stomp all over this notion of other
> categories you've invented now before people actually start trying to
> use them.
> 
> There are also two other axes that this approach neglects. Trusted
> (another boolean) and bitrate (a scalar).

No. Read this:
I will explain it once again: It is _just_ to select a default policy
of which RNG is initialized by default. The type does say _nothing_
about the entropy quality or something else. It _just_ judges about
which RNG is preferred for default initialization.
External RNG boards are preferred over internal onboard stuff; onboard
is preferred over bad RNGs like bcm43xx; bcm43xx is preferred over
devices that are not RNGs by definition but could be used as such (sensors).

-- 
Greetings Michael.
