Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYDMT1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYDMT1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYDMT10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:27:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYDMT1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:27:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reporting bugs and bisection (was: Re: 2.6.25-rc8: FTP transfer errors)
Date: Sun, 13 Apr 2008 21:27:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Willy Tarreau <w@1wt.eu>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <47FEADCB.7070104@rtr.ca> <20080413184730.GD8474@1wt.eu> <20080413121831.d89dd424.akpm@linux-foundation.org>
In-Reply-To: <20080413121831.d89dd424.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132127.58067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of April 2008, Andrew Morton wrote:
> On Sun, 13 Apr 2008 20:47:30 +0200 Willy Tarreau <w@1wt.eu> wrote:
> 
> >  One other thing which might get confusing/frustrating on the
> > user side is that currently, Linux is the *only* product which requires
> > the bug reporter to find the fault change
> 
> That's because many (probably most) Linux bugs are dependent upon the
> hardware which they run on, and developers cannot reproduce the failure on
> their hardware.  Other software products don't have that problem.
> 
> 
> That being said..  four or five years ago, developers would often work
> closely with the reporter working out why the reporter's failure was
> occurring.  Several days of back-and-forth.
> 
> We dont' do that as much nowadays - there's a tendency to
> 
> a) throw the problem back at the reporter, often asking them to bisect. 
>    If the reporter is running a distro kernel (eg: Fedora) then that's
>    quite hard, and often isn't a think they have knowledge to do.  So
>    they'll just disappear.  Or
> 
> b) just ignore the report altogether.

IMHO we should try to make that difficult.
