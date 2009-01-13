Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZAMOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZAMOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZAMOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:43:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:45940 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754090AbZAMOnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:43:11 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18e/RQoi1ceoaLDDoDTUGWIUnqi8G7QvBFrGDfj3B
	WG06I4mTE6su5e
Date: Tue, 13 Jan 2009 15:43:07 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090113144307.GF16333@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1231857643.29164.28.camel@think.oraclecorp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 15:42:23 up  6:36, 10 users,  load average: 0.84, 0.26, 0.29
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason (chris.mason@oracle.com) wrote:
> On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > Hi,
> > 
> > when mounting an intentionally corrupted btrfs filesystem i get the
> > following warning and bug message. The image can be found here
> > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> 
> Thanks for looking at things
> 
> Aside from catching checksumming errors, we're not quite ready for
> fuzzer style attacks.  The code will be hardened for this but it isn't
> yet.

Does this mean i should stop trying to break it for now or are you interested
in further reports?

Greetings, Eric
