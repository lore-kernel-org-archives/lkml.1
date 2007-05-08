Return-Path: <linux-kernel-owner+w=401wt.eu-S967136AbXEHWfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967136AbXEHWfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032493AbXEHWfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:35:05 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:29539 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1032478AbXEHWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:35:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KmWf3bMDpQ3si6wi1V85lsAwcwhd/W2Lz+4bwexaRJS7M+wO/cdhq6CJm8hjm7OE+M4lOJcCC2NXQJHGw8/b0UADxABJWAdrEa6ZnPcvhqbQycg4+e0hKFQA+XlD/cEpjUP5BByU8HbqyWDtyGLUKTZnV6jmbdgPTGsF9uCHx0A=  ;
X-YMail-OSG: _IoPGSwVM1k1I2wVX0nYFFeyG5GoqGjHMqCgor1RYd9PK.r.Xl2Ors6gmjAvTepfcdMGAy5kRQ--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] different values for OHCI_QUIRK_ZFMICRO
Date: Tue, 8 May 2007 15:34:56 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>
References: <20070111222627.66bb75ab.akpm@osdl.org> <200703291524.01834.david-b@pacbell.net> <20070508151753.8a8df27c.rdunlap@xenotime.net>
In-Reply-To: <20070508151753.8a8df27c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081534.57057.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007, Randy Dunlap wrote:
> On Thu, 29 Mar 2007 15:24:00 -0700 David Brownell wrote:
> 
> > On Thursday 29 March 2007 3:06 pm, Randy Dunlap wrote:
> > > On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:
> > > 
> > > > On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> > > > > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > > > > > <--  snip  -->
> > > > > 
> > > > > Waiting for Tony to submit bugfixes to his driver...
> > > > 
> > > > Still unfixed as of 2.6.20-mm1.
> > >
> > > so is there a patch around for this yet?
> > > 
> > > or shall someone other than Tony (??) make one?
> > 
> > ISTR posting the appended patch back in January; it's been
> > refreshed since then.  Presumably it still works.
> > 
> > - Dave
> 
> Oh, Greg, can we get this merged some day soon, please?
> David posted this patch on 2007-FEB-08.

And reposted it 2007-APR-29 too, after refresh ...

