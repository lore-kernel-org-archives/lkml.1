Return-Path: <linux-kernel-owner+w=401wt.eu-S1764435AbYD0X6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764435AbYD0X6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYD0X6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:58:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYD0X6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=C+7Xz7vBKxyPuU7WEMe9vHbr9lwp1/At0RE4Ysl0pU0vLEIUbPW2h9+vZTj34quhZ536hUl6g1+H/Idu22oQ58o603RAT0UQ4K2Oo4OqBVRQW52S8hT9EqmNgMHqyvkESRViXszR0v+hgeSKTB/hvr2DcXFYMxJwiRljHcf/2G4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Mon, 28 Apr 2008 01:57:12 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <200804261651.02078.vda.linux@googlemail.com> <20080427234056.GA108924158@sgi.com>
In-Reply-To: <20080427234056.GA108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280157.12736.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008 01:40, David Chinner wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> 
> Can you please attach your patches inline, Denys (see
> Documentation/SubmittingPatches)?

I can, but Kmail is notorious for mangling them :(

Is it ok if I will paste them inline AND attach them too,
so that you get guaranteed-nonmangled one in attachment?

> I have a set of patches that introduces new functionality into the
> allocator (dynamic allocation policies) that reduces
> xfs_bmap_btalloc() function by 36 bytes (just by chance, I didn't
> design it for this purpose). It breaks it down on functional
> boundaries like Christoph's patch. I'm going to revist that patch
> w.r.t both these patches and see what falls out the bottom...

Nice to know that.

Can you point me to svn/CVS/git/whatever which holds latest xfs
devel tree?
--
vda
