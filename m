Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYHUKsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYHUKsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYHUKsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:48:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:32867 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbYHUKsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:48:46 -0400
Subject: Re: BUG in free_block (tainted)
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
References: <48A9E97B.6060601@simon.arlott.org.uk>
	 <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
	 <48A9ECD2.8030801@simon.arlott.org.uk>
	 <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 12:48:43 +0200
Message-Id: <1219315723.8651.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 00:49 +0300, Pekka Enberg wrote:

> Aww, apparently the fglrx driver creates tons of SLAB caches with
> really funky names for no good reason... Oh well, one more reason to
> stay away from that crap and help out the nouveau folks instead ;-).

fglrx is the AMD/ATI binary evilness - the open source efforts are the
radeon and radeonhd drivers. AMD/ATI are actually providing
documentation and paying developers to work on the drivers.

I'm not sure what the nvidia binary wonkyness is called, but its
respective open source effort is the nouveau - who must solely reply on
reverse engineering as nvidia isn't providing anything.

Anyway - your point still stands - binary stuff should not be used.

