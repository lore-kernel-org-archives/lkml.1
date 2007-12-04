Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbXLDSDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbXLDSDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXLDSD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:03:27 -0500
Received: from waste.org ([66.93.16.53]:43747 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXLDSD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:03:26 -0500
Date: Tue, 4 Dec 2007 12:02:37 -0600
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204180237.GU19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204165502.0a8f695e@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 04:55:02PM +0000, Alan Cox wrote:
> > cryptographically strong stream it'll provide when /dev/random is
> > tapped? In principle, this'd leave more entropy available for
> > applications that really need it, especially on platforms that don't
> > generate a lot of entropy in the first place (servers).
> 
> 
> As reported about a month ago, the evidence is that the /dev/random
> stream is not cryptographically strong. Collecting uuids generated from
> the kernel uuid random generator from the random generator in the kernel
> shows abnormal patterns of duplicates.

Pointer, please.

-- 
Mathematics is the supreme nostalgia of our time.
