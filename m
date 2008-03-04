Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbYCDAQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbYCDAQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYCDAPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:15:55 -0500
Received: from ozlabs.org ([203.10.76.45]:38128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYCDAPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:15:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH] lguest: fix undefined asm-offsets symbols
Date: Tue, 4 Mar 2008 11:14:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       fedora-kernel-list@redhat.com
References: <20080220202152.GA9990@phobos.i.cabal.ca>
In-Reply-To: <20080220202152.GA9990@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041114.47772.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 07:21:52 Kyle McMartin wrote:
> lguest uses asm-offsets to generate ... offsets, obviously, for use
> in the lguest switcher code. When the hypervisor code is built as a
> module though, the asm offsets it needs won't be generated since
> CONFIG_LGUEST will be undefined.
>
> Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

Thanks Kyle,

   This is in Linus' tree now thanks to Ingo.  I had a slightly different fix 
which I mistakenly hadn't pushed, but this works fine.

Cheers,
Rusty.
