Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXCKEPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXCKEPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933052AbXCKEPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:15:35 -0500
Received: from waste.org ([66.93.16.53]:43894 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbXCKEPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:15:34 -0500
Date: Sat, 10 Mar 2007 22:03:05 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
Message-ID: <20070311040305.GT10394@waste.org>
References: <20070311013506.GD10459@waste.org> <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com> <20070311040132.GS10394@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311040132.GS10394@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 10:01:32PM -0600, Matt Mackall wrote:
> On Sun, Mar 11, 2007 at 01:28:22PM +1100, Con Kolivas wrote:
> > Ok I don't think there's any actual accounting problem here per se
> > (although I did just recently post a bugfix for rsdl however I think
> > that's unrelated). What I think is going on in the ccache testcase is
> > that all the work is being offloaded to kernel threads reading/writing
> > to/from the filesystem and the make is not getting any actual cpu
> > time.
> 
> I don't see significant system time while this is happening.

Also, it's running pretty much entirely out of page cache so there
wouldn't be a whole lot for kernel threads to do.

-- 
Mathematics is the supreme nostalgia of our time.
