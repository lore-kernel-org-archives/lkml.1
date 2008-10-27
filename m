Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYJ0SGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYJ0SGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYJ0SGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:06:13 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42289 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbYJ0SGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:06:12 -0400
Date: Mon, 27 Oct 2008 14:05:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>, Jan Kara <jack@ucw.cz>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 2/2 take 2] ext4: fix a bug accessing freed memory in
	ext4_abort
Message-ID: <20081027180530.GA23111@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Vegard Nossum <vegard.nossum@gmail.com>, Jan Kara <jack@ucw.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com> <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com> <20081027104325.GA13641@elte.hu> <4905A99F.8000605@hitachi.com> <4905AAF2.8020302@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4905AAF2.8020302@hitachi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks, Kawai-san, it looks good.  I'll get this queued for
mainline.

		   	 	     	 - Ted
