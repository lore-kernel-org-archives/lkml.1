Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbXGQW0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbXGQW0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXGQW0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:26:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbXGQW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:26:44 -0400
Date: Tue, 17 Jul 2007 15:25:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roland Dreier <rdreier@cisco.com>, Jeff Garzik <jgarzik@redhat.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
 warnings
In-Reply-To: <20070717151906.27208ebf.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707171524460.27353@woody.linux-foundation.org>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
 <ada8x9epuip.fsf@cisco.com>
 <20070717151906.27208ebf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Andrew Morton wrote:
> 
> (rofl, look at that mess: it was utterly impractical, unrealistic and
> stupid for gcc to go and UTFify the compiler output.  Sigh.  LANG=C, guys).

Yeah, I absolutely *detest* how gcc does idiotic quoting just because you 
happen to be in a UTF-8 locale. There's no reason for it what-so-ever, and 
I don't understand the mindset of whoever did that crap.

They should use a nice ASCII tick-mark ('), not some fancy quotation 
marks.

		Linus
