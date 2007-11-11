Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXKKNo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXKKNo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 08:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXKKNos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 08:44:48 -0500
Received: from main.gmane.org ([80.91.229.2]:35345 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbXKKNos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 08:44:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas <gimpel@sonnenkinder.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Date: Sun, 11 Nov 2007 13:43:27 +0000 (UTC)
Message-ID: <loom.20071111T133858-314@post.gmane.org>
References: <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost> <20071101141414.GZ25561@iucha.net> <E1InlPV-0001f1-SL@localhost> <20071102021002.GF25561@iucha.net> <E1Inw51-0001e8-PS@localhost> <20071102133239.GI25561@iucha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.135.2.202 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071105 Firefox/2.0.0.9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Iucha <florin <at> iucha.net> writes:

> > It's really curious - I tried your .config and commands, and still
> > could not trigger the high iowait. I'm running 64bit Intel Core 2,
> > and kernel 2.6.24-rc1-git6 with the above patch.
> 
> Curious but 100% reproducible, at least on my box.  What I'm going to
> try is booting into the kernel with your patch and just doing the find
> / md5sum.  It would be really interesting if the read-only access
> triggers it.
> 
> florin
> 

I can confirm this issue too on any .24-rc. I'm also using reiserfs on a LVM.

And there is one more user on Gentoo forums having the same issue.
http://forums.gentoo.org/viewtopic-t-612959.html

So you are not alone, florian.

