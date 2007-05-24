Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXEXUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXEXUDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXEXUDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:03:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38615 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXEXUDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:03:42 -0400
Date: Thu, 24 May 2007 22:04:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linux-sparc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Linker script cleanup / consolidation
Message-ID: <20070524200440.GA1109@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With basis in sparc64 I did a small cleanup / consolidation work.
The sparc64 lds script is by no menas the worst to look at but
a anyway a good place to start.

In the following patch serie I did:
-> Introduce a C-like indention style
-> Introduce use of PAGE_SIZE as replacement for hardcoded constant
-> Consoildate initramfs definition


While browsing the other arch lds files I saw many other smaller
items that could be consolidated but creating a define for
something like 3-5 lines was to push it too much.

If there are a number of sections that could be defined together
I would like to combine then in a common section but I do 
know too little about the linker scripts to determine this.

The other archs shall have a similar clean-up over time.
sparc64 was just a good place to start because David had
expressed that he liked the consolidation.

	Sam
