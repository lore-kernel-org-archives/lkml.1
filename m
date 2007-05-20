Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbXETWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbXETWcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXETWcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:32:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52476 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbXETWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:32:16 -0400
Date: Sun, 20 May 2007 18:22:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@suse.de>
Cc: Folkert van Heusden <folkert@vanheusden.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       righiandr@users.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520222247.GA25276@c2.user-mode-linux.org>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <20070520212036.GL22452@vanheusden.com> <20070520222422.GT2012@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520222422.GT2012@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 12:24:22AM +0200, Andi Kleen wrote:
> > > But I think your list is far too long anyways.
> > 
> > So, which ones would you like to have removed then?
> 
> SIGFPE at least and the accounting signals are dubious too. SIGQUIT can
> be also relatively common.

And SIGSEGV and SIGBUS - UML catches these internally and handles them.

				Jeff
