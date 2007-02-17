Return-Path: <linux-kernel-owner+w=401wt.eu-S1946503AbXBQIt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946503AbXBQIt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946514AbXBQIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:49:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52660 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946503AbXBQIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:49:58 -0500
Date: Sat, 17 Feb 2007 00:49:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Message-Id: <20070217004946.51bde229.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
	<20070215205658.56096f97.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
	<20070215214506.f795acc4.akpm@linux-foundation.org>
	<20070215215125.9161e3dc.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702152158210.12571@montezuma.fsmlabs.com>
	<20070215230243.515ec6b3.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702160500210.31650@montezuma.fsmlabs.com>
	<20070216102206.343e0b0d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007 00:35:52 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:

> On Fri, 16 Feb 2007, Andrew Morton wrote:
> 
> > On Fri, 16 Feb 2007 06:39:45 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:
> > 
> > > On Thu, 15 Feb 2007, Andrew Morton wrote:
> > > 
> > > > It's not an X problem - the screen is black immediately upon loading the
> > > > kernel.
> > > > 
> > > > But I guess you knew that and you're just after display info:
> > > > http://userweb.kernel.org/~akpm/Xorg.0.log.txt
> > > 
> > > Thanks, the X log told me your VBE version. I tried to reproduce it on my 
> > > thinkpad which seems to have a very similar video setup to no avail, Could 
> > > you test the following on the VAIO? If this isn't the case, i suspect i'm 
> > > corrupting your modelist.
> > 
> > It's still all black.
> 
> Ok it looks like i was corrupting the modelist. The following should take 
> care of your VAIO, but i haven't tested the failure case as Tobias is away 
> this weekend.

yup, no longer all black.

