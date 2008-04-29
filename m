Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYD2L2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYD2L2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYD2L14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:27:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37552 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYD2L1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:27:55 -0400
Date: Tue, 29 Apr 2008 14:27:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429112718.GD19269@cs181133002.pp.htv.fi>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429104216.GC19269@cs181133002.pp.htv.fi> <20080429110638.GG1473@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429110638.GG1473@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:06:38PM +0200, Willy Tarreau wrote:
> On Tue, Apr 29, 2008 at 01:42:16PM +0300, Adrian Bunk wrote:
> > On Tue, Apr 29, 2008 at 12:09:34PM +0200, Willy Tarreau wrote:
>...
> > > Unicode yes, UTF-8 no. UTF-8 is a compressed encoding of unicode.
> > > That's as silly as if you had to replace your terminals to read
> > > native gzip, and expect them as well as all the tools to work
> > > properly!
> > 
> > It's not a compressed encoding, it's a variable-length encoding.
> > 
> > Besides the size advantages one main advantage of UTF-8 is that ASCII is 
> > valid UTF-8. This means that for the ASCII source code in the kernel it 
> > doesn't matter whether it's treated as ASCII or UTF-8, and no conversion 
> > was needed.
> > 
> > You can't get this property with a fixed-size Unicode encoding.
> 
> I don't agree. If you refuse character-set mixing, there's no problem.
> Bit 7 of first char == 1 ? => full text is 32 bit.

You miss my point.

The point is:
A conversion "ASCII -> UTF-8" is a nop.

This means when changing the kernel from half a dozen charsets used in 
comments to UTF-8 we only had to change the few characters actually 
containing non UTF-8.

Going to something like UTF-32 as you suggest would have involved 
converting every single file in the kernel.

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

