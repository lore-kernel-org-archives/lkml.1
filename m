Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXHAJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXHAJSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXHAJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:18:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60916 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXHAJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:18:33 -0400
Subject: Re: ATA over ethernet swapping
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       kernel list <linux-kernel@vger.kernel.org>, ak@suse.de,
       Netdev list <netdev@vger.kernel.org>
In-Reply-To: <20070731222742.GR2087@elf.ucw.cz>
References: <20070731135831.GA4604@elf.ucw.cz>
	 <20070731150324.GE3206@coraid.com> <20070731152924.GM2087@elf.ucw.cz>
	 <20070731162140.GI3206@coraid.com>  <20070731222742.GR2087@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:18:29 +0200
Message-Id: <1185959909.12034.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on this for quite some time. And should post again
soon. Please see the patches:

  http://programming.kicks-ass.net/kernel-patches/vm_deadlock/current/

For now it requires one uses SLUB, I hope that SLAB will go away (will
save me the trouble of adding support) and I guess I ought to do SLOB
some time (if that does stay).

You'd need the first 22 patches of that series, and then call
sk_set_memalloc(sk) on the proper socket, and do some fiddling with the
reconnect logic. See nfs-swapfile.patch for examples.


