Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYL1Nhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYL1Nhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 08:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYL1NhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 08:37:15 -0500
Received: from corega.com.ru ([195.178.208.66]:57910 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbYL1NhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 08:37:14 -0500
Date: Sun, 28 Dec 2008 16:37:11 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dst@ioremap.net, netdev@vger.kernel.org
Subject: Re: [0/7] Distributed storage release.
Message-ID: <20081228133711.GA858@ioremap.net>
References: <1230292576-23963-1-git-send-email-zbr@ioremap.net> <20081226191701.GA1761@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226191701.GA1761@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 08:17:02PM +0100, Pavel Machek (pavel@suse.cz) wrote:
> > Its main goal of the project is to allow creation of the block devices
> > on top of different network media and connect physically distributed devices
> > into single storage using existing network infrastructure and not
> > introducing new limitations into the protocol and network usage model.
> 
> So it is basically nbd on steroids?

Kind of... In this regard any network device which transfers IO and
related requests over the network is a nbd on steroids.

> ...reminds me, nbd-server should really fsync data before returning success...

There are lots of issues NBD could have at first... When I compared DST
with AoE and NFS, Debian Lenny/Etch's nbd server crashed on startup, so
I was not able to run my tests against it.

-- 
	Evgeniy Polyakov
