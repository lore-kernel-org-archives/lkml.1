Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZHKSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZHKSxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZHKSxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:53:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZHKSxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:53:33 -0400
Date: Tue, 11 Aug 2009 11:52:21 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Peterson <joe@skyrush.com>
Cc: Artur Skawina <art.08.09@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving tty->stopped logic to ldisc (pty: fix data loss when
 stopped (^S/^Q))
Message-ID: <20090811185221.GA4750@suse.de>
References: <4A81B587.8070902@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A81B587.8070902@skyrush.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 12:16:39PM -0600, Joe Peterson wrote:
> [Please include my email address in replies]
> 
> Hi all,
> 
> This is in regard to the problem that the recent patch ("pty: fix data
> loss when stopped (^S/^Q)") fixes.  The issue is something I've been
> looking at recently as well after noticing (I noticed it first as loss
> of echoes, since I was re-testing what my echo buffer code originally
> fixed).

Hm, is this resolved by git id 85dfd81dc57e8183a277ddd7a56aa65c96f3f487
that Linus commited to the tree yesterday?

thanks,

greg k-h
