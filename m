Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbYJRUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbYJRUyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYJRUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:54:27 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:37236 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752607AbYJRUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:54:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZHRgvkS4b0egDMfd5OWMRw+qet/tiAKuUD38Q+1wIO7nxKhlRICHd/Z2fIHt28dKh5sqpQm574bhpMTndBGtD+si8ABwA205/McM1jMu/shNDONJFk5QQSYM0/Jf4+oKjPUZaR9X0G0si47z8CYX0zgvapJd11VKcEba4RjVFic=  ;
X-YMail-OSG: xSmmgPEVM1kAirIsBBHRj1BNEKuU4jezrxaDNOULYqZ7POiOs18BHHlW5hp3nfJzR5cHaP2tESNkdbh1hagpEVlE7bwBXPQb0qHYjTk08YnQ.21aeO0GPWcQ1Avm17zcVZj7DsAwBedWnigTw_zpFkyl
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Piotr Skamruk" <piotr.skamruk@gmail.com>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Date: Sat, 18 Oct 2008 13:54:23 -0700
User-Agent: KMail/1.9.9
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Magnus Damm" <magnus.damm@gmail.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200807202146.12759.mb@bu3sch.de> <200810181132.24233.mb@bu3sch.de> <6179c79b0810181341g584d0466s6a2abb68b786be38@mail.gmail.com>
In-Reply-To: <6179c79b0810181341g584d0466s6a2abb68b786be38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181354.23955.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 October 2008, Piotr Skamruk wrote:
> 2008/10/18 Michael Buesch <mb@bu3sch.de>:
> > On Saturday 18 October 2008 06:36:31 Andrew Morton wrote:
> >> This patch has some "issues" a month or so ago.  Current status is that
> >
> > yeah, upstream maintainers don't like these patches.
> > Please drop this one and the "gpiommc" patch now.
> >
> As i remember - David stands that these patches (or even
> functionality) are not usable for him, so he don't want to see them in
> mainstream kernel sources. It's his choice, he is maintainer of this
> subsystem.

That patch is very limited, and wrong in several respects.

I fully support the idea of SPI over GPIO.  It's just that
particular patch which is problematic.


> You have this on openwrt svn, I have it on my dev gittree - and as You
> can see on Magnus example - anybody interested can google for it.
> Maybe if there will be next few peoples - David will change his
> opinion on this subject...

I'm sanity testing a refresh of the *original* late-2006
SPI-over-GPIO driver.  It's actually usable as a drop-in
replacement for a "native" driver.

Unfortunately I goofed and pulled down the current GIT tree
and found lots of unrelated breakage (non-SPI) that's keept
that sanity test from proceeding apace.  And the board on
which it's most recently been used is currently broken.
I may just send that patch out soon, as an FYI...

- Dave

