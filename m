Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852Ab0A0Bsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0A0Bsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022Ab0A0Bsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:48:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:34272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0A0Bsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:48:33 -0500
Date: Tue, 26 Jan 2010 17:47:26 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
Message-ID: <20100127014726.GA1196@suse.de>
References: <20100126191624.538119758@mini.kroah.org>
 <m1bpggy7bt.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain>
 <20100126230402.GB24281@suse.de>
 <alpine.LFD.2.00.1001261729510.24199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001261729510.24199@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 05:30:46PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Jan 2010, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > Subject: fnctl: f_modown should call write_lock_irqsave/restore
> 
> Ok, applied and pushed out as b04da8b, so you can add it to the -stable 
> list.

Thanks, I'll go queue it up now.

greg k-h
