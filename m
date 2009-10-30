Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZJ3KtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZJ3KtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZJ3KtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:49:14 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15711 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZJ3KtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:49:13 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=1XWaLZrsAAAA:8
 a=P-gv2VgPma3YqXCDNFMA:9 a=5T_pUizhnu6uIx5KIYYA:7
 a=_5tUt4XMtjJxBooX8yO7z5uQTRIA:4 a=UTB_XpHje0EA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
Date: Fri, 30 Oct 2009 04:49:17 -0600
User-Agent: KMail/1.12.2 (Linux/2.6.26-2-amd64; KDE/4.3.2; x86_64; ; )
References: <hav57c$rso$1@ger.gmane.org> <alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com> <20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910300449.17992.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri October 30 2009, KAMEZAWA Hiroyuki wrote:
> On Fri, 30 Oct 2009 02:10:37 -0700 (PDT)
> 
> David Rientjes <rientjes@google.com> wrote:
> > >    - The kernel can't know the program is bad or not. just guess it.
> >
> > Totally irrelevant, given your fourth point about /proc/pid/oom_adj. 
> > We can tell the kernel what we'd like the oom killer behavior should be
> > if the situation arises.
> 
> My point is that the server cannot distinguish memory leak from
>  intentional memory usage. No other than that.
> 
> > >    - Then, there is no "correct" OOM-Killer other than fork-bomb
> > > killer.
> >
> > Well of course there is, you're seeing this is a WAY too simplistic
> > manner.  If we are oom, we want to be able to influence how the oom
> > killer behaves and respond to that situation.  You are proposing that
> > we change the baseline for how the oom killer selects tasks which we
> > use CONSTANTLY as part of our normal production environment.  I'd
> > appreciate it if you'd take it a little more seriously.
> 
> Yes, I'm serious.
> 
> In this summer, at lunch with a daily linux user, I was said
> "you, enterprise guys, don't consider desktop or laptop problem at all."
> yes, I use only servers. My customer uses server, too. My first priority
> is always on server users.
> But, for this time, I wrote reply to Vedran and try to fix desktop
>  problem. Even if current logic works well for servers, "KDE/GNOME is
>  killed" problem seems to be serious. And this may be a problem for
>  EMBEDED people, I guess.

Whats worse is a friend of mine gets stuck with a useless machine for a 
couple hours or more when oom tries to do its thing. It swap storms for 
hours. Not a good thing imo.

[snip]


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
