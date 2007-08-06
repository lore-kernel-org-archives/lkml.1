Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXHFQHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXHFQHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXHFQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:07:22 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:29851 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752179AbXHFQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:07:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HaLSbpTVbS7CXmf0Cu5r90HcqVUZJKTAD6r/QFoulMHbOB/GuM2cdeg1o8KOSL8P7ewi3sNN6ph/XsoXKmpu7ou+anJFWcTQAzk0s4TvyTl+cG88Cp6lhHKE2R4x/M2S/YW+S6gaEeREp6+4yX4nN31pnkalzXbr5AMar1nxPu4=  ;
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>, bryan.wu@analog.com
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
Date: Mon, 6 Aug 2007 09:07:02 -0700
User-Agent: KMail/1.9.6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <1186318969.16030.2.camel@roc-laptop> <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
In-Reply-To: <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708060907.02506.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2007, Mike Frysinger wrote:
> On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > Bryan Wu (4):
> >       Blackfin SPI driver: Initial supporting BF54x in SPI driver
> >
> > Michael Hennerich (11):
> >       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
> >       Blackfin arch: add peripheral resource allocation support
> >       Blackfin arch: Add label to call new GPIO API
> >       Blackfin SPI driver: Make BF54x SPI work and add support for portmux API
> >       Blackfin SPI driver: use new GPIO API and add error handling
> 
> i think this is the sort of thing Linus wants left for initial merge windows ?

What, merging patches that have never even been seen by the relevant
subsystem maintainer(s)?

I've never seen any of those SPI patches before, and am not inclined
to try plucking three of them out of a composite patch for a separate
review ...

Same goes for GPIO, for that matter.  It's harder to goof those up,
but it's still possible.  If those were reviewed I personally might
be inclined to OK merges after RC1; GPIOs get used almost everywhere.
(Pretty much as Bryan commented...)  Those look more like portmux
changes than GPIO changes though.

- Dave
