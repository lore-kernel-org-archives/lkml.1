Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbXEZCRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbXEZCRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 22:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXEZCRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 22:17:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44082 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXEZCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 22:17:35 -0400
Date: Fri, 25 May 2007 22:10:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current utrace breaks UML
Message-ID: <20070526021013.GA11490@c2.user-mode-linux.org>
References: <20070523121902.GA4365@c2.user-mode-linux.org> <20070526013513.E894D1F8511@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070526013513.E894D1F8511@magilla.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 06:35:13PM -0700, Roland McGrath wrote:
> Oops!  I overlooked the need to preserve the orig_eax value, though its
> necessity is obvious.  This makes me wonder about those previous
> reports that UML was working OK.

The one from me was on x86_64, where PTRACE_SYSEMU isn't an issue yet.

> I've fixed this in the latest utrace patch set.  I also wired up
> sysemu on x86_64.  This means 32-bit processes calling ptrace now
> support it for full compatibility with native i386, which the vanilla
> kernel does not.  It also means it works for 64-bit ptrace calls,
> whether operating on a 64-bit or a 32-bit target process.

Beautiful!

				Jeff

-- 
Work email - jdike at linux dot intel dot com
