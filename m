Return-Path: <linux-kernel-owner+w=401wt.eu-S968269AbYD1XMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968269AbYD1XMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967965AbYD1XFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:05:38 -0400
Received: from 1wt.eu ([62.212.114.60]:3487 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968125AbYD1XFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:05:35 -0400
Date: Tue, 29 Apr 2008 01:05:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080428230524.GK8474@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428154023.GU2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 06:40:23PM +0300, Adrian Bunk wrote:
> This patch converts some non-UTF-8 encoded text in comments to UTF-8.

Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
everyone reads UTF-8. Now I get random crappy chars which cripple my
xterms when reading such comments, and I have to do a full-reset once
I've read them. It's not as if it was *that* important, and to be
honnest, if you had not sent this patch, I would not even have known
that non-ASCII characters were here. However, it will quickly get
annoying if a recursive grep returns those pesky codes on non-compatible
consoles...

Quite frankly, it does not bring anything beyond trouble. I'm not adding
a NAK here because I find this rude, but I don't like the orientation
we're taking with the sources. We should not force people to install
version X or Y of a particular system just to read sources.

In fact, I would have better converted accentuated chars to their ASCII
equivalent to be more friendly with people who only read 7-bit.

Regards,
Willy

