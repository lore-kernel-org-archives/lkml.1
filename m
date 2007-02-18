Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXBRVzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXBRVzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXBRVzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:55:43 -0500
Received: from ns.suse.de ([195.135.220.2]:35927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXBRVzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:55:43 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Date: Sun, 18 Feb 2007 22:53:10 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com> <20070216102206.343e0b0d.akpm@linux-foundation.org> <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
In-Reply-To: <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702182253.10423.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 09:35, Zwane Mwaikambo wrote:
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

I merged this version of the patch now. Still needs some x86-64 testing
I guess (any volunteers?), although I don't expect much trouble
because the early boot code is very similar.

-Andi

> 
