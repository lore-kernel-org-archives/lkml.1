Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZF2VOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZF2VOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZF2VOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:14:38 -0400
Received: from kroah.org ([198.145.64.141]:45246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZF2VOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:14:37 -0400
Date: Mon, 29 Jun 2009 13:45:57 -0700
From: Greg KH <greg@kroah.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       stefan.bader@canonical.com, woodys@xandros.com, penberg@cs.helsinki.fi,
       Jesse Barnes <jbarnes@virtuousgeek.org>, apw@canonical.com,
       Andrew Morton <akpm@linux-foundation.org>, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] [Intel-gfx] Intel 915GM MCHBAR bug
Message-ID: <20090629204557.GB29647@kroah.com>
References: <4A298971.5080006@xandros.com> <4A2A0951.1020608@cs.helsinki.fi> <20090605232711.d8503262.akpm@linux-foundation.org> <4A2A0E8C.1010109@cs.helsinki.fi> <20090606212759.31970fae@jbarnes-x200> <20090609150757.4a2109a9@jbarnes-x200> <20090609152828.d82528f3.akpm@linux-foundation.org> <20090629173308.GB3901@kroah.com> <20090629182738.GD3901@kroah.com> <4A490D47.7030305@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A490D47.7030305@pardus.org.tr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:51:51PM +0300, Ozan Çağlayan wrote:
> Greg KH wrote:
> > I take it back.  It doesn't build properly on 2.6.30, can someone
> > backport commit d765898970f35acef960581f678b9da9d5c779fa to the 2.6.30
> > tree and send it to stable@kernel.org so that we can apply it to resolve
> > this issue?
> > ease read the FAQ at  http://www.tux.org/lkml/
> >   
> 
> There was this commit on top of them which was fixed the build problem
> for me:
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fanholt%2Fdrm-intel.git;a=commitdiff_plain;h=34c8638bb5ee130b8151c57708284bcd4972e2e1;hp=003c9ca68810bc0a63a1f3ff6beec839b197e23b

No, the issue is the pnp_resource() call, that's not present in 2.6.30.

Can someone backport whatever is needed in .30 and send it to us?

thanks,

greg k-h
