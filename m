Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYJaMzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYJaMzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYJaMzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:55:05 -0400
Received: from lazybastard.de ([212.112.238.170]:42997 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYJaMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:55:03 -0400
Date: Fri, 31 Oct 2008 13:54:53 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031125453.GE18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225452761.3535.28.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 12:32:41 +0100, Johannes Berg wrote:
> > > 
> > > Would there be an easy way to use 48-bit keys? Or variable length keys?
> > 
> > Variable as in one implementation for several trees with different
> > sizes, yes.  Variable as in one tree with differently sized keys, no.
> 
> Ok, I guess that would blow up the key size to 6+1+32 bytes, or 10 (5)
> longs. Bit large.

Yes.  Insanely large keys are a good indication to better avoid btrees.

> > > I think the wireless case would probably want to have real shrinking
> > > because it's well possible that you're moving, with your laptop, from an
> > > area with a large number of APs to say your home out in the countryside
> > > that only has your single AP.
> > 
> > Indeed.
> 
> I guess not then for now, unless one of us wants to implement
> resizing... I'll look for replacements another time, nobody has
> complained yet about the huge hash table :)

I actually have something that compiles now.  It still needs a bit of
water and soap before I'd consider it presentable, but turned out to be
less complicated than expected.

Jörn

-- 
More computing sins are committed in the name of efficiency (without
necessarily achieving it) than for any other single reason - including
blind stupidity.
-- W. A. Wulf
