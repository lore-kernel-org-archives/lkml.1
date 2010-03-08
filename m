Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab0CHG0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:26:12 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:56762 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CHG0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:26:07 -0500
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 01:26:07 EST
Date: Mon, 8 Mar 2010 08:04:06 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: The gregkh patch scripts
Message-ID: <20100308060405.GA3885@gandalf>
Reply-To: me@felipebalbi.com
References: <20100307181649.GD3718@kroah.com>
 <Pine.LNX.4.44L0.1003071546000.8502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003071546000.8502-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 07, 2010 at 03:54:25PM -0500, Alan Stern wrote:
> Let's ask some other people on the USB list (CC'ed).  My main concern 
> is to avoid rebasing too often, whichever source-code management system 
> is used.

personally, I'm more used to git and find it difficult (or annoying) when
I need to rebase my own patches on top of Greg's quilt tree. git
quiltimport doesn't work always and I have to refresh patches on my own
and run git quiltimport later again.

Moving to a git tree would help me, but then again, I don't want to
become a burden. Whatever is better for Greg, I'll be adapating to ;-)

What I use currently to have a tree which people can pull from and still
be able to rebase on top of Greg's patches is something like:

$ git fetch linus
$ git reset --hard linus/master
$ git quiltimport --patches gregkh
$ git rebase greg my_patches
$ git merge -s ours master
$ git checkout master
$ git merge my_patches

it helps although rebuilding the tree always is a bit messy :-p

-- 
balbi

