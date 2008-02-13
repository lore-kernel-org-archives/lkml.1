Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYBMKiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYBMKiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYBMKhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:37:53 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55671 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYBMKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:37:52 -0500
Date: Wed, 13 Feb 2008 05:36:41 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213103641.GD12785@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, jeff@garzik.org,
	arjan@infradead.org, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com> <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org> <20080213061653.GA10784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213061653.GA10784@kroah.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:16:53PM -0800, Greg KH wrote:
> I was amazed at how slow stgit was when I tried it out.  I use
> git-quiltimport a lot and I don't think it's any slower than just using
> quilt on its own.  So I think that the speed issue should be the same.

I like using "guilt" because I can easily reapply the patchset using
"guilt push -a", which is just slightly fewer characters to type than
"git-quiltimport".  This also means that I don't need to switch back
and forth between "git mode" and "quilt mode" when I'm editing the
patches (either directly by editing the patch files, in which case
afterwards I do a "guilt pop -a; guilt push -a", or by using "guilt
pop", "guilt push", and "guilt refresh").

"guilt push -a" is a little bit slower than "quilt push -a", but not
enough to be seriously annoying.  And besides, "guilt pop -a" is
slightly faster than "quilt pop -a".

Using guilt is also nice because there is a bit of additional backup
for previous work via the git reflogs, although to be honest I've
rarely needed to use it.

						- Ted
