Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYDNAgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYDNAgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYDNAgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:36:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:53481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYDNAgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:in-reply-to:message-id:lines:user-agent:mime-version:content-type:date;
        b=ezCfP9RvKGWkeWlrg+mZ2VGNWjvBHqZNDFVYyBW8qTRiPEZS+7tDOz/0g3g47426btAsbrPeY3zH+onrwrD5L6JvCiKpIt33bnhaq22ED7KCbfQLX6M3Z9TSPWFnMc4WB5uhPgr4cqxFeOFKAk2MtdXhNNRrsJKa6rK466UrQ7E=
To: david@lang.hm
Cc: Stephen Clark <sclark46@earthlink.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Tilman Schmidt <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel <linux-kernel@vger.kernel.org>, git@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
References: <47FEADCB.7070104@rtr.ca>
	<20080413121831.d89dd424.akpm@linux-foundation.org>
	<20080413202118.GA29658@2ka.mipt.ru> <200804132233.50491.rjw@sisk.pl>
	<20080413205406.GA9190@2ka.mipt.ru> <48028830.6020703@earthlink.net>
	<alpine.DEB.1.10.0804131546370.9318@asgard>
From: Jakub Narebski <jnareb@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0804131546370.9318@asgard>
Message-ID: <m3ve2ls26p.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 13 Apr 2008 17:36:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> cross-posted to git for the suggestion at the bottom

[...]

> Elsewhere in this thread someone said that the pre-git way was to do a
> manual bisect where the developer would send patches backing out
> specific changes to find the problem. one big difference between that
> and bisecting the problem is that the manual process was focused on
> the changes in the area that is suspected of causing the problem,
> while the git bisect process goes after all changes. this makes it
> much more likely that the tester will run into unrelated problems
> along the way.
> 
> I wonder if it would be possible to make a variation of git bisect
> that only looked at a subset of the tree when picking bisect points
> (if you are looking for a e1000 bug, testing bisect points that
> haven't changed that driver won't help you for example). If this can
> be done it would speed up the reporters efforts, but will require more
> assistance from the developers (who would need to tell the reporters
> what subtrees to test) so it's a tradeoff of efficiancy vs simplicity.

Errr... the synopisis of git-bisect contains the following:

 git bisect start [<bad> [<good>...]] [--] [<paths>...]

so you can limit bisection to commits affecting specified subsystem.

P.S. Unfortunately git currently doesn't deal with directory renames,
so if there was sime big code restructuring one has to provide all
historic pathspecs.

-- 
Jakub Narebski
Poland
ShadeHawk on #git
