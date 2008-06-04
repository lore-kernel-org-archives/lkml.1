Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbYFDTic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbYFDTic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762608AbYFDTiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:38:15 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40774 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762602AbYFDTiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:38:13 -0400
Date: Wed, 4 Jun 2008 15:37:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       dhazelton@enter.net, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080604193715.GA11943@c2.user-mode-linux.org>
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org> <20080603210048.GA12182@c2.user-mode-linux.org> <4846A75E.40305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846A75E.40305@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 03:31:58PM +0100, Jeremy Fitzhardinge wrote:
> Shouldn't UML use a monotonic host clock for guest timekeeping?

Indeed, Eric pointed out the posix timers, which I had forgotten
about.  On the face of it, a monotonic timer should do the trick, but
it's not obvious how to get it to behave like a monotonic
gettimeofday...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
